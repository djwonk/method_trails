require 'require_relative'
require_relative '/../classes/atom'

class MethodTrails
  class Rule
    module Capture

      attr_reader :captured

      # Clear captured variables.
      def clear_captured!
        @captured = nil
      end

      # Take tentative +captures+ (from a +Match+ object) and make them
      # a permanent part of a +Rule+ object.
      #
      # Some context:
      # * Match objects store only tentative captures.
      # * Rule objects store finalized captures.
      #
      # This method appends +captures+ onto +@captured+:
      #
      # For example:
      #   @captured = { "a" => [:def], "b" => [:@kw] }
      #   captures  = { "a" => [:class, :module] }
      #   finalize_captures(captures)
      #   @captured = { "a" => [:def, :class, :module], "b" => [:@kw] }
      # 
      def finalize_captures(captures)
        return unless captures && !captures.empty?
        @captured ||= {}
        @captured.merge!(captures) do |k, left, right|
          left.dup.concat(right)
        end
      end
      
    end
  end
end
