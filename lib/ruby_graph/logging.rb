class RubyGraph
  module MethodCalls
    module Logging

      def log_atom(atom, pos)
        increment_debug_line
        "%04d %*s%p\n" % [@n, pos.length, "", atom]
      end

      def log_s_exp(s_exp, pos, matches)
        increment_debug_line
        output = get_matches_and_captures(matches)
        "%04d %*s[%s\n" % [@n, pos.length, "", output]
      end

      def get_matches_and_captures(matches)
        return "" if !matches || matches.empty?
        output = matches.collect do |rule|
          if rule.captured
            "<#{rule.label}: #{rule.captured}>"
          else
            "<#{rule.label}>"
          end
        end
        " #{matches.length} " + output.join(" ")
      end

      def increment_debug_line
        @n ||= 0
        @n += 1
        $debug_line = @n
      end
      
    end
  end
end
