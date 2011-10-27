class MethodTrails
  class AtomException < RuntimeError; end
  class Atom

    def atom?; true end

    # Capture +atom+
    def capture(atom)
      raise AtomException unless self.capturing?
      if self.match?(atom)
        atom.value
      end
    end

    # Try to capture +atom+.
    # Raises fewer exceptions than +capture+.
    def try_capture(atom)
      return nil unless self.capturing?
      if self.match?(atom)
        atom.value
      end
    end

    # Is this a capturing atom?  A capturing atom is used to find a match and
    # capture (store) it.
    #
    #   * See the +to_atom+ method to see how various objects are converted
    #     to capturing atoms.
    #
    #   * See +Capture+ to see how the captured value is stored.
    #
    def capturing?
      @capture_on ? true : false
    end

    # Create an atom.
    #   * If +capture_on+ is false, create a regular atom.
    #   * If +capture_on+ is true, create a capturing atom.
    #
    # Raises +AtomException+ if +thing+ is invalid.
    def initialize(thing, capture_on=false)
      @thing      = thing
      @capture_on = capture_on
      raise AtomException, "#{thing} is invalid" unless self.valid?
    end

    def inspect
      if @capture_on
        "%" + @thing.inspect
      else
        @thing.inspect
      end
    end

    # Does +self+ match +atom+?
    #
    # Raises error if +atom+ is not a regular atom.
    def match?(atom)
      unless atom.respond_to?(:atom?) && atom.atom? && atom.regular?
        raise AtomException, "#{atom.inspect} must be a regular atom"
      end
      if @capture_on
        @thing.class == atom.value.class
      else
        @thing == atom.value
      end
    end

    # Is this a regular atom?
    # A regular atom is used to find a match, but not capture it.
    def regular?
      @capture_on ? false : true
    end

    def s_exp?; false end

    # Human readable version of the atom.
    # % signifies a capturing atom.
    def to_s
      if @capture_on
        "%" + @thing.to_s
      else
        @thing.to_s
      end
    end

    # Atoms are valid if they are one of these kinds of objects:
    #   * Integer, String, Symbol
    #   * TrueClass, FalseClass, NilClass
    def valid?
      case @thing
      when Integer, String, Symbol then true
      when TrueClass, FalseClass, NilClass then true
      else false
      end
    end

    def value
      @thing
    end

    def ==(atom)
      return false unless atom.respond_to?(:atom?) && atom.atom?
      @thing == atom.value
    end

  end
end

module Atomable
  def to_atom(disable_capturing = true)
    if disable_capturing
      # Create a regular atom
      MethodTrails::Atom.new(self)
    else
      # Create a capturing atom
      MethodTrails::Atom.new(self, true)
    end
  end
end

class TrueClass;  include Atomable end
class FalseClass; include Atomable end
class NilClass;   include Atomable end
class Integer;    include Atomable end

class String
  def to_atom(disable_capturing=false)
    if disable_capturing || self[0] != '%'
      # Create a regular atom
      MethodTrails::Atom.new(self)
    else
      # Create a capturing atom
      MethodTrails::Atom.new(self[1..-1], true)
    end
  end
end

class Symbol
  def to_atom(disable_capturing = false)
    if disable_capturing || self[0] != '%'
      # Create a regular atom
      MethodTrails::Atom.new(self)
    else
      # Create a capturing atom
      MethodTrails::Atom.new(self[1..-1].intern, true)
    end
  end
end
