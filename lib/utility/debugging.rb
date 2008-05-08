class MethodTrails
  class Rule
    module Debugging
    
      def dputs(level, string)
        return
        # $debug_line ||= 0
        # @n ||= 1
        # if true # || level <= 6 || string =~ /captured/
        #   puts "%04d:%05d%s|%s" % [$debug_line, @n, " " * @depth, string]
        # end
        # @n += 1
      end

    end
  end
end
