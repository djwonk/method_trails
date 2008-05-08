require 'require_relative'
require_relative '/actual/actual'

class MethodTrails
  class Rules
    
    # Load the 'actual' rules
    def self.list
      rs = []
      [ 
        Actual.rules,
      ].each { |rules| rs.concat rules }
      rs
    end
    
  end
end
