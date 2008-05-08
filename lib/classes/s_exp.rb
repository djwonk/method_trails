require 'require_relative'
require_relative '/atom'

class MethodTrails
  class SExpException < RuntimeError; end
  class SExp < Array
    
    attr_accessor :disable_capturing
    
    def atom?; false end

    # Return all children that are atoms
    def atoms
      self.find_all { |x| x.atom? }
    end
    
    def initialize(*args)
      super
      @disable_capturing = false
      convert
    end
    
    # Do a depth-first search to make sure that all elements are
    # either Atom or SExp objects.
    def valid?
      return false unless self.respond_to?(:each)
      self.all? do |x|
        if x.respond_to?(:atom?) && x.atom?
          x.valid?
        elsif x.respond_to?(:s_exp?) && x.s_exp?
          x.valid?
        else
          false
        end
      end
    end
    
    # Return a pretty representation, i.e. indented nicely.
    def pretty
      @d = 0
      _pretty(self)
    end

    def replace(*args)
      super
      convert
    end

    def s_exp?; true end

    # Return all children that are s-expressions
    def s_exps
      self.find_all { |x| x.s_exp? }
    end
    
    protected
    
    def _pretty(s_exp)
      o = ""
      o << _indent(@d) + "[\n"
      @d += 1
      s_exp.each do |e|
        if e.atom?
          o << _indent(@d) + "#{e.inspect}\n"
        elsif e.s_exp?
          o << _pretty(e)
        else
          raise SExpException, "#{e.inspect} is invalid"
        end
      end
      @d -= 1
      o << _indent(@d) + "]\n"
      o
    end
    
    def _indent(depth)
      "  " * depth
    end

    # Recurse through self and convert inner objects to SExp or Atom.
    # Intended to be called by +initialize+ and +replace+.
    # Raises +SExpException+ if conversion fails.
    def convert
      self.each_with_index do |x, i|
        if x.respond_to?(:to_atom)
          self[i] = x.to_atom(@disable_capturing)
        elsif x.respond_to?(:to_s_exp)
          # Did not work: se = SExp.new(x)
          se = SExp.new
          se.disable_capturing = @disable_capturing
          se.replace(x)
          self[i] = se
        else
          raise SExpException, "#{x.inspect} must respond to :to_atom or :to_s_exp"
        end
      end
      raise SExpException, "Internal error" unless self.valid?
    end
    
  end
end

class Array
  
  def to_s_exp(disable_capturing = false)
    s_exp = MethodTrails::SExp.new
    s_exp.disable_capturing = disable_capturing
    s_exp.replace(self)
    s_exp
  end
  
end
