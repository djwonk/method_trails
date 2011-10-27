require 'require_relative'
require_relative '/traverse'
require_relative '/../classes/s_exp'

class MethodTrails
  class TraverserException < RuntimeError; end
  class Traverser

    attr_accessor :atom_callback
    attr_accessor :s_exp_callback

    def initialize(s_exp)
      unless s_exp.respond_to?(:s_exp?) && s_exp.s_exp?
        raise TraverserException, "s-expression required"
      end
      @entire_s_exp   = s_exp
      @atom_callback  = lambda {}
      @s_exp_callback = lambda {}
    end

    # Run the traversal.
    def run
      self.s_exp_callback.call(@entire_s_exp, [])
      traverse(@entire_s_exp, [])
    end

    protected

    include Traverse

  end
end
