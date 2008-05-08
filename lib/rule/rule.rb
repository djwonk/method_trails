require 'require_relative'
require_relative '/rule_match'
require_relative '/capture'
require_relative '/../classes/match'
# require_relative '/../utility/debugging'

class MethodTrails
  class RuleException < RuntimeError; end
  # A Rule describes a potential match with a 'subject' s-expression.
  #
  # A Rule always tells you if there is a match or not.  Optionally, it may
  # also capture a variable in a match so that you can use it later.
  #
  class Rule
    
    # The rule in s-expression format.
    #
    # For example:
    #   [
    #     :__child,
    #     [
    #       :class,
    #       :const_ref
    #     ]
    #   ].to_s_exp
    #
    attr_accessor :s_exp
    
    # In the future, I hope to allow a Rule to be specified in a more
    # compact form, such as ":class > :const_ref"
    attr_accessor :name
    
    # An identifier for the Rule.  Preferably short.  May be used for
    # console logging and output.
    attr_accessor :label
    
    # Does the subject (+subject_s_exp+) match the Rule one or more times?
    def match?(subject)
      self.matches(subject) > 0
    end

    # Does the subject (+subject+) match the Rule one or more times?
    #   +subject+ : must be an SExp object
    #
    # If rule contains matching atoms, then the captured results will be
    # stored.  See MethodTrails::Rule::Capture.
    def matches(subject)
      matches = 0
      # Create an initial match object to store the match head
      initial = Match.new(subject, nil, subject, nil)
      each_match(self.s_exp, subject, initial) do |match|
        raise RuleException unless match.kind_of?(Match) # See note 1
        matches += 1
        finalize_captures(match.captured)
      end
      matches
    end
    
    # Create a copy of +match+ while setting new values for +tail_sibl+
    # and +tail_index+.  Preserves values such as +head_sibl+, +head_index+,
    # and +captures+.
    #
    # If +head_index+ is not already set, set it.
    #
    def copy_match_with_new_tail(match, tail_sibl, tail_index)
      raise RuleException unless match && match.kind_of?(Match)
      _match            = match.clone
      _match.tail_sibl  = tail_sibl
      _match.tail_index = tail_index
      _match.head_index ||= tail_index
      _match
    end

    # Note that there may also be captured variables -- these are side
    # effects, not tied to the return value.
    include Capture
  
    # In the future, Rule may be specified in a more compact form, such as
    # ":class > :const_ref".
    #
    # The operators are somewhat similar to CSS:
    #   +       adjacent sibling
    #   ~       general sibling
    #   >       child
    #   (space) descendant
    #
    SELECTORS = {
      "+" => :__adjacent_sibling,
      ">" => :__child,
      " " => :__descendant,
      "~" => :__general_sibling,
    }
    SELECTOR_STRINGS = SELECTORS.keys
    SELECTOR_SYMBOLS = SELECTORS.values

    include RuleMatch
    # include Debugging

  end
end

# ------
# Note 1
# ------
#
# Being a stickler about the type can help find small/obvious
# problems before they become large/unobvious!
