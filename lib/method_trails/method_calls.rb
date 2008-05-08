require 'require_relative'
require_relative '/logging'
require_relative '/../classes/s_exp'
require_relative '/../traverser/traverser'
require_relative '/../rules/rules'

class MethodTrails
  module MethodCalls

    attr_accessor :log_filename

    # Returns a hash that contains the information extracted when running
    # the rules.
    #
    # Typically the top level of the hash contains keys that match up with
    # the labels of the various rules.  For example:
    #
    #   :classes_and_i_methods
    #   :i_methods_and_ids
    #
    # Below the top level, the hash's structure is driven by what each rule
    # requests to be captured.  For example:
    #
    #   { :classes_and_i_methods =>
    #     [
    #       {
    #         "class" => ["MusicalPerformance"],
    #         "def"   => ["initialize"]
    #       }
    #     ]
    #   }
    #
    #   Or another example:
    #
    #   { :i_methods_and_ids => 
    #     [
    #       {
    #         "ident" => ["announce_song", "gets_quieter"],
    #         "def"   => ["initialize",    "initialize"]
    #       }
    #     ]
    #   }
    # 
    def get_method_calls(s_exp)
      raise "SExp expected" unless s_exp.s_exp?
      t = Traverser.new(s_exp)
      @log = ""
      @graph = {}
      t.atom_callback  = lambda do |atom, pos|
        @log << log_atom(atom, pos)
      end
      t.s_exp_callback = lambda do |s_exp, pos|
        matches = execute_rules(s_exp, pos)
        @log << log_s_exp(s_exp, pos, matches)
        clear_captures
      end
      t.run
      write_log_file(@log)
      @graph
    end
    
    protected
    
    # Rules do not change "on the fly", so cache them.
    RULES = Rules.list

    def execute_rules(subject_s_exp, pos)
      RULES.find_all do |rule|
        match_count = rule.matches(subject_s_exp)
        if match_count > 0
          @graph[rule.label] ||= []
          @graph[rule.label] << rule.captured
        end
      end
    end
    
    def clear_captures
      RULES.find_all do |rule|
        rule.clear_captured!
      end
    end
    
    include Logging

  end
end
