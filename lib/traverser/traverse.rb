require 'require_relative'
require_relative '/../classes/atom'
require_relative '/../classes/s_exp'

class RubyGraph
  class Traverser
    module Traverse

      # Traverse +s_exp+ using a depth-first traversal.
      #
      # Yields to these callbacks:
      #   * atom_callback
      #   * s_exp_callback
      #
      # Parameters:
      #   * +s_exp+    : subject s-expression 
      #   * +position+ : tracks our position relative to @entire_s_exp
      #
      # TODO: may need +label+
      #
      def traverse(s_exp, position)
        unless s_exp.respond_to?(:s_exp?) && s_exp.s_exp?
          raise TraverserException, "+s_exp+ must be s-expression"
        end
        s_exp.each_with_index do |element, i|
          pos = position + [i]
          # Since we have access to @entire_s_exp, element, i, and pos, we
          # can create any number of useful intermediate data structures,
          # including but not limited to:
          #
          #   * ancestors
          #   * siblings
          #
          # These data structures could be handed off to the callbacks.
          #
          if element.respond_to?(:atom?) && element.atom?
            traverse_atom(element, pos)
          elsif element.respond_to?(:s_exp?) && element.s_exp?
            traverse_s_exp(element, pos)
          else
            raise TraverserException, "Internal error"
          end
        end
      end
      
      protected
      
      def traverse_atom(element, pos)
        # If necessary, we can calculate siblings or other data structure
        self.atom_callback.call(element, pos)
      end
      
      def traverse_s_exp(element, pos)
        self.s_exp_callback.call(element, pos)
        traverse(element, pos)
      end

    end
  end
end
