class RubyGraph
  module Abbreviate
    
    MAX = 70
    
    def abbrev(obj, max = MAX)
      s = obj.inspect
      if s.length <= max
        s
      else
        s[0...max] + "..."
      end
    end

  end
end
