require 'require_relative'
require_relative '/../rule/rule'
require_relative '/../classes/s_exp'

class RubyGraph
  class Rules
    module Factory

      def rule_factory(label, name, s_exp)
        r       = Rule.new
        r.label = label
        r.name  = name
        r.s_exp = s_exp.to_s_exp
        r
      end
      
    end
  end
end
