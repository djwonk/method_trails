require 'require_relative'
require_relative '/capture'
require_relative '/typed_match'
require_relative '/../classes/match'
# require_relative '/../utility/abbreviate'
# require_relative '/../utility/debugging'

class MethodTrails
  class Rule
    module RuleMatch

      # Each time +rule_s_exp+ matches +subject_s_exp+, iterate over block
      # (+b+), passing a Match object as the parameter.
      #
      # Parameters:
      #   +rule+    : s-expression for a Rule (or portion of a Rule)
      #   +subject+ : s-expression for the subject (i.e. parsed Ruby)
      #   +b+       : called for each match (block or lambda)
      #
      # Return value:
      #   Using the block (+b+) means that the return value is not needed.
      # 
      # More information:
      #
      #   Note that the +rule_s_exp+ drives the process.  There is no need
      #   to dig deeper into +subject_s_exp+ than the rule cares about.
      #
      #   Note that by match we mean a 'head to toe' match; starting at the
      #   head, moving to the toes.*  First, we check for a match between
      #   the top of the Rule and the top of the expression.  If that
      #   succeeds, we go down one level.  And so on.
      #
      #   * Yes, a rule can branch, therefore having more than one toe.
      #     Though such rules seem messy, they can be quite useful.
      #
      def each_match(rule, subject, match, &b)
        unless rule.respond_to?(:s_exp?) && rule.s_exp? && rule.valid?
          raise "rule not valid SExp : #{rule.inspect}"
        end
        unless subject.respond_to?(:s_exp?) && subject.s_exp? && subject.valid?
          raise "subject not valid SExp : #{subject.inspect}"
        end
        type = get_type(rule)
        if not type
          process_untyped_rule(rule, subject, match, &b)
        else
          break_apart_typed_rule(type, rule, subject, match, &b)
        end
      end

      protected
      
      # Process untyped +rule+ directly.  Untyped means that +rule+ does
      # not contain a type such as :__child, :__descendant, or so on.
      #   +rule+    : must be SExp
      #   +subject+ : must be SExp
      #
      # (This is the base case of +each_match+.)
      def process_untyped_rule(rule, subject, match, &b)
        case rule.length
        when 1
          process_rule_atom(nil, rule[0], subject, match, false, &b)
        else
          raise RuleException, "Malformed rule"
        end
      end
      
      # Process +rule+ that is only one atom.
      #   +type+    : may be nil or a symbol
      #   +rule+    : must be an Atom
      #   +subject+ : must be SExp
      def process_rule_atom(type, rule, subject, match, permissive, &b)
        unless rule.respond_to?(:atom?) && rule.atom?
          raise RuleException, "rule must be an Atom"
        end
        each_possible_matches_with_index(permissive, type, subject) do |element, i|
          if element.respond_to?(:atom?) && element.atom? && rule.match?(element)
            _match = copy_match_with_new_tail(match, subject, i)
            _match.tentative_capture(rule, element)
            _match.future = get_future_for_type(type, _match)
            yield(_match)
          end
        end
      end
      
      # Break apart +rule+ into sub-rules.
      #   +type+ must be a Symbol, such as :__adjacent_sibling
      #   +rule+ must be an SExp
      #   +subject+ must be SExp
      #
      # (This is the recursion step of +each_match+.)
      def break_apart_typed_rule(type, rule, subject, match, &b)
        # type = rule[0].atom? && rule[0].value
        case rule[1].length
        when 2
          process_binary_rule(type, rule, subject, match, &b)
        when 3
          process_ternary_rule(type, rule, subject, match, &b)
        else
          raise RuleException, "Malformed rule"
        end
      end

      # Process a rule (a binary relation) using typed rules.
      #   +type+ must be a Symbol, such as :__general_sibling
      #   +rule+ must be an SExp
      #   +subject+ must be SExp
      def process_binary_rule(type, rule, subject, match, &b)
        if type.is_a?(Array)
          raise RuleException, "Only simple type allowed here"
        end
        rule_x, rule_y = rule[1]
        each_typed_rule(type, rule_x, rule_y, subject, match, &b)
      end

      # Process a rule (a ternary relation) using typed rules.
      #   +type+ must be a Symbol, such as :__descendant
      #   +rule+ must be an SExp
      #   +subject+ must be SExp
      def process_ternary_rule(type, rule, subject, match, &b)
        rule_x, rule_y, rule_z = rule[1]
        type_xy, type_xz = convert_to_compound_type(type)
        each_typed_rule(type_xy, rule_x, rule_y, subject, match) do |match_xy|
          match_1 = match.clone
          match_1.append_captures(match_xy.captured)
          each_typed_rule(type_xz, rule_x, rule_z, subject, match_1) do |match_xz|
            if match_xz.head_index == match_xy.head_index
              yield(match_xz)
            end
          end
        end
      end

      # Is +rule+ a typed rule?
      #    +rule+ must be an SExp
      def get_type(rule)
        r0 = rule[0]
        types = [
          :__adjacent_sibling,
          :__child,
          :__descendant,
          :__general_sibling,
        ]
        if r0.atom? && types.include?(r0.value)
          r0.value
        elsif r0.s_exp? && r0.length == 2
          a, b = r0
          if(a.atom? && types.include?(a.value) &&
             b.atom? && types.include?(b.value))
            [a.value, b.value] # compound type
          end
        end
      end
      
      def convert_to_compound_type(type)
        if type.is_a?(Symbol)
          [type, type]
        elsif type.is_a?(Array) && type.length == 2
          type
        else
          raise RuleException, "Malformed type"
        end
      end

      def get_future_for_type(type, match)
        case type
        when nil
          []
        when :__child
          match.semantic_children
        when :__descendant
          match.semantic_descendants
        when :__adjacent_sibling, :__general_sibling
          match.younger_semantic_siblings
        else
          raise RuleException, "Unrecognized type: #{type}"
        end
      end
      
      def each_possible_matches_with_index(permissive, type, subject)
        possibilities = case type
        when nil, :__child, :__descendant, :__general_sibling
          subject
        when :__adjacent_sibling
          subject.take(1)
        else
          raise RuleException, "Unrecognized type: #{type}"
        end
        # If permissive, override what was chosen by type
        possibilities = subject if permissive
        possibilities.each_with_index do |element, i|
          yield(element, i)
        end
      end
      
      include TypedMatch
      # include Abbreviate
      # include Debugging
      
    end
  end
end
