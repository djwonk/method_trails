require 'require_relative'
# require_relative '/../utility/debugging'

class MethodTrails
  class Rule
    module RuleMatch
      module TypedMatch

        # Each time the rule matches +subject_s_exp+, iterate over block (+b).
        #
        # Parameters:
        #   +type+    : rule type (Symbol), i.e. :__child
        #   +rx+      : left part of rule (Atom or SExp)
        #   +ry+      : right part of rule (Atom or SExp)
        #   +subject+ : the subject being explored (SExp)
        #
        def each_typed_rule(type, rx, ry, subject, match, &b)
          each_typed_rule_match(type, rx, subject, match, true) do |match_x|
            each_future(type, match_x) do |nested|
              each_typed_rule_match(type, ry, nested, match_x, false) do |match_y|
                yield(match_y)
              end
            end
          end
        end

        protected

        # Each time the +rule+ matches +subject+, iterate over the
        # block (+b+), passing a properly configured Match object.  The
        # Match object will guide the caller.  Note that +rule+ is either
        # an Atom or SExp, not a Rule.
        #
        #  +permissive+ : Be more permissive with atom matching.
        #               : See context in +each_typed_rule+.
        def each_typed_rule_match(type, rule, subject, match, permissive, &b)
          if rule.atom?
            process_rule_atom(type, rule, subject, match, permissive, &b)
          elsif rule.s_exp?
            process_typed_rule_s_exp(type, rule, subject, match, &b)
          else
            raise RuleException, "Internal error"
          end
        end
        
        # +rule+ must be an SExp
        def process_typed_rule_s_exp(type, rule, subject, match, &b)
          each_match(rule, subject, match) do |match_1|
            _match = match_1.clone
            # Q: Should we set head_index here?
            # A: I am pretty sure that we should not.  Besides, even if we
            #    wanted to, what would we use for the index value?  We
            #    would need an index of an atom -- but we are not at the
            #    level where we see atoms yet.  This is why head_index is
            #    properly handled by +process_rule_atom+.
            _match.future = get_future_for_type(type, _match)
            yield(_match)
          end
        end

        def each_future(type, match)
          case type
          when :__child, :__descendant
            match.future.each { |x| yield(x) }
          when :__adjacent_sibling, :__general_sibling
            yield(match.future)
          else
            raise RuleException, "Unrecognized type: #{type}"
          end
        end
        
        # include Debugging
        
      end
    end
  end
end
