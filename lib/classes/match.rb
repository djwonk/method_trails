require 'require_relative'
require_relative '/atom'
require_relative '/s_exp'

class RubyGraph
  class MatchException < RuntimeError; end
  
  # A +Match+ is an object passed back from +each_match+ and its family of
  # methods.
  #
  # Ultimately, all matches between rules and s-expressions happen because
  # their component atom(s) match up.
  #
  # A +Match+ object contains information about the match, including:
  #
  #   1. the atom that matched
  #      Do I mean the most recent atom that matched?
  #      Do I mean the top-most atom that matched?
  #      Do I mean the bottom-most atom that matched?
  #
  #   2. s-expression containing the atom that matched
  #
  #
  #   3. semantic children of the atom that matched
  #
  # It might be helpful to know that a Match knows nothing about the
  # Rule that caused the match to happen.
  #
  class Match
    
    attr_accessor :captured

    # An array of s-expressions that are next in line to be searched if the
    # match is still pending (i.e. tentative).  Setting this to an empty
    # array, i.e. [], indicates that no more searching is needed.
    attr_accessor :future

    attr_accessor :head_sibl
    attr_accessor :head_index
    attr_accessor :tail_sibl
    attr_accessor :tail_index

    # This method appends +captures+ onto +@captured+:
    #
    # For example, in the beginning:
    #   @captured = { "a" => ["const_ref"], "b" => ["var_ref"] }
    #   captures  = { "a" => ["def", "class"] }
    #   append_captures(captures)
    #   @captured = { "a" => ["const_ref", "def", "class"], "b" => ["var_ref"] }
    # 
    def append_captures(captures)
      return unless captures && !captures.empty?
      @captured ||= {}
      @captured.merge!(captures) do |k, left, right|
        left.concat(right)
      end
    end

    def head
      @head_sibl[@head_index]
    end

    # Returns the head and semantic children of the head.
    #
    # Criteria for selecting children:
    #   * Find the younger siblings (i.e. ones with higher indices)
    #   * Match only s-expressions
    #   * Stop if another atom is reached
    #
    # Return value:
    #   * An s-expression
    # 
    # Note: The return value is an s-expression, not just an array.
    def head_and_semantic_children
      hsc = [].to_s_exp
      hsc << head
      hsc.concat(@head_sibl.drop(@head_index + 1).take_while { |e| e.s_exp? })
      hsc
      # I don't know why but the following does not work:
      # @head_sibl.drop(@head_index + 1).take_while { |e| e.s_exp? }.to_s_exp
    end

    # Create a new Match object.
    #
    # Parameters:
    #   +head+       : The siblings of the match's head / top. (SExp)
    #   +head_index+ : Index of +head+ for the match's head. (Integer)
    #   +tail+       : The siblings of the match's tail / bottom. (SExp)
    #   +tail_index+ : Index of +tail+ for the match's tail. (Integer)
    #
    def initialize(head_sibl, head_index, tail_sibl, tail_index)
      assert_valid(head_sibl, head_index, tail_sibl, tail_index)
      @head_sibl  = head_sibl
      @head_index = head_index
      @tail_sibl  = tail_sibl
      @tail_index = tail_index
      @future     = []
      @captured   = nil
    end
    
    def initialize_copy(orig)
      @head_sibl  = @head_sibl.dup
      @head_index = @head_index
      @tail_sibl  = @tail_sibl.dup
      @tail_index = @tail_index
      @future     = @future.dup
      begin
        @captured = @captured.dup
      rescue TypeError # dup not allowed (or needed)
      end
    end

    def older_adjacent_sibling
      @tail_sibl[@tail_index - 1]
    end

    def older_siblings
      @tail_sibl[0 .. (@tail_index - 1)]
    end

    # Returns the semantic children of a match.
    #
    # Criteria for selecting children:
    #   * Find the younger siblings (i.e. ones with higher indices)
    #   * Match only s-expressions
    #   * Stop if another atom is reached
    #
    # Return value:
    #   * An array of one or more s-expressions.
    # 
    # Note: The return value is an array, not an s-expression.
    # It is important that the caller iterate through it to get
    # the s-expressions inside.
    def semantic_children # of tail
      @tail_sibl.drop(@tail_index + 1).take_while { |e| e.s_exp? }
    end
    
    def semantic_descendants
      _descendants(semantic_children)
    end
    
    def siblings(including_me=false)
      if including_me
        @tail_sibl
      else
        p = @tail_sibl.dup
        p.delete_at(@tail_index)
        p
      end
    end
    
    def tail
      @tail_sibl[@tail_index]
    end

    # A capture is tentatively made.  It will not be "permanent" the
    # calling Rule says with +finalize_captures+.
    #
    def tentative_capture(rule_atom, subject_atom)
      raise RuleException unless rule_atom.atom?
      result = rule_atom.try_capture(subject_atom)
      if result
        key = rule_atom.value
        @captured      ||= {}
        @captured[key] ||= []
        @captured[key] << result
      end
    end
    
    # Not Needed
    # def younger_adjacent_semantic_sibling
    #   yass = [].to_s_exp 
    #   yss = younger_semantic_siblings
    #   yass.concat(yss.take(1))
    #   yass.concat(yss.drop(1).take_while { |e| e.s_exp? })
    #   yss
    # end

    def younger_adjacent_sibling
      younger_siblings[0]
    end

    # Returns the younger semantic siblings of match tail.
    #
    # Return value:
    #   * An s-expression
    # 
    # Note: The return value is an s-expression, not just an array.
    def younger_semantic_siblings # of tail
      yss = [].to_s_exp
      yss.concat(@tail_sibl.drop(@tail_index + 1).drop_while { |e| e.s_exp? })
      yss
      # I don't know why but the following does not work:
      # @tail_sibl.drop(@tail_index + 1).drop_while { |e| e.s_exp? }.to_s_exp
    end
    
    def younger_siblings
      @tail_sibl.drop(@tail_index + 1)
      # @tail_sibl[(@tail_index + 1) .. -1]
    end

    def ==(m)
      return false unless m.kind_of?(Match)
      @head_sibl  == m.head_sibl &&
      @head_index == m.head_index &&
      @tail_sibl  == m.tail_sibl &&
      @tail_index == m.tail_index &&
      @captured   == m.captured &&
      @future     == m.future
    end
    
    protected
    
    # Find descendants of +s_exp+.
    def _descendants(s_exp)
      result = []
      s_exp.each do |element|
        if element.s_exp?
          result << element
          result.concat(_descendants(element))
        end
      end
      result
    end

    def assert_valid(head_sibl, head_index, tail_sibl, tail_index)
      raise "head_sibl must be an SExp" unless head_sibl.s_exp?
      raise "tail_sibl must be an SExp" unless tail_sibl.s_exp?
      if head_index
        raise "head_index must be an Integer"   unless head_index.kind_of?(Integer)
        raise "head_index must be >= 0"         unless head_index >= 0
        raise "head_index must be in head_sibl" unless head_index < head_sibl.length
        raise "head_index must be an Atom"      unless head_sibl[head_index].atom?
      end
      if tail_index
        raise "tail_index must be an Integer"   unless tail_index.kind_of?(Integer)
        raise "tail_index must be >= 0"         unless tail_index >= 0
        raise "tail_index must be in tail_sibl" unless tail_index < tail_sibl.length
        raise "tail_index must be an Atom"      unless tail_sibl[tail_index].atom?
      end
    end
    
  end 
    
end
