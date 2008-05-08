require 'test/unit'
require 'require_relative'
require_relative '/../../lib/classes/atom'

module ShouldBeAnAtom
  def test_should_be_of_atom_class
    assert_equal(MethodTrails::Atom, @atom.class)
  end
  def test_should_respond_to_atom?
    assert(@atom.respond_to?(:atom?))
  end
  def test_should_be_an_atom
    assert(@atom.atom?)
  end
  def test_should_be_valid
    assert(@atom.valid?)
  end
  def test_should_respond_to_s_exp?
    assert(@atom.respond_to?(:s_exp?))
  end
  def test_should_not_be_an_s_exp
    assert_equal(false, @atom.s_exp?)
  end
end

module ShouldBeARegularAtom
  def test_should_be_regular_atom
    assert(@atom.regular?)
  end
  include ShouldBeAnAtom
end

module ShouldBeACapturingAtom
  def test_should_be_capturing_atom
    assert(@atom.capturing?)
  end
  include ShouldBeAnAtom
end

module ShouldNotBeConvertibleToAtom
  def test_should_raise_atom_exception
    assert_raise(MethodTrails::AtomException) do
      MethodTrails::Atom.new(@attempted_contents)
    end
  end
end

module ShouldMatchAnyString
  def test_should_match_any_string
    assert(@atom.match?("government".to_atom))
    assert(@atom.match?("for the".to_atom))
    assert(@atom.match?("people".to_atom))
  end
end

module ShouldNotMatchAnyString
  def test_should_not_match_any_string
    assert_equal(false, @atom.match?("government".to_atom))
    assert_equal(false, @atom.match?("for the".to_atom))
    assert_equal(false, @atom.match?("people".to_atom))
  end
end

module ShouldMatchAnyInteger
  def test_should_match_any_integer
    assert(@atom.match?(5.to_atom))
    assert(@atom.match?(50.to_atom))
    assert(@atom.match?(500.to_atom))
  end
end

module ShouldNotMatchAnyInteger
  def test_should_not_match_any_integer
    assert_equal(false, @atom.match?(5.to_atom))
    assert_equal(false, @atom.match?(50.to_atom))
    assert_equal(false, @atom.match?(500.to_atom))
  end
end

module ShouldMatchAnySymbol
  def test_should_match_any_symbol
    assert(@atom.match?(:cymbal.to_atom))
    assert(@atom.match?(:timpani.to_atom))
    assert(@atom.match?(:xylophone.to_atom))
  end
end

module ShouldNotMatchAnySymbol
  def test_not_should_match_any_symbol
    assert_equal(false, @atom.match?(:cymbal.to_atom))
    assert_equal(false, @atom.match?(:timpani.to_atom))
    assert_equal(false, @atom.match?(:xylophone.to_atom))
  end
end

module ShouldRaiseExceptionWhenAttemptingCapture
  def test_should_raise_exception_when_attempting_capture
    assert_raise(MethodTrails::AtomException) do
      @atom.capture(@attempted_capture)
    end
  end
end

module ShouldReturnNilFromTryCapture
  def test_try_capture_integer_should_fail
    assert_equal(nil, @atom.try_capture(40.to_atom))
  end
  def test_try_capture_string_should_fail
    assert_equal(nil, @atom.try_capture("cheese".to_atom))
  end
  def test_try_capture_symbol_should_fail
    assert_equal(nil, @atom.try_capture(:symbol.to_atom))
  end
end

# ====================

class TestNilAtom < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(nil)
  end
  include ShouldBeAnAtom
end

class TestFalseAtom < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(false)
  end
  include ShouldBeAnAtom
end

class TestTrueAtom < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(true)
  end
  include ShouldBeAnAtom
end

# --------------------

class TestIntegerToRegularAtom < Test::Unit::TestCase
  def setup
    @atom = 8.to_atom
  end
  include ShouldBeARegularAtom
end

class TestIntegerToCapturingAtom < Test::Unit::TestCase
  def setup
    @atom = 8.to_atom(false)
  end
  include ShouldBeACapturingAtom
end
  
class TestStringToRegularAtom < Test::Unit::TestCase
  def setup
    @atom = "a string".to_atom
  end
  def test_to_s
    assert_equal("a string", @atom.to_s)
  end
  include ShouldBeARegularAtom
end

class TestStringToCapturingAtom < Test::Unit::TestCase
  def setup
    @atom = "%a capturing string".to_atom
  end
  def test_to_s
    assert_equal("%a capturing string", @atom.to_s)
  end
  include ShouldBeACapturingAtom
end

class TestSymbolToRegularAtom < Test::Unit::TestCase
  def setup
    @atom = :a_symbol.to_atom
  end
  def test_inspect
    assert_equal(":a_symbol", @atom.inspect)
  end
  include ShouldBeARegularAtom
end

class TestSymbolToCapturingAtom < Test::Unit::TestCase
  def setup
    @atom = :"%a capturing symbol".to_atom
  end
  def test_inspect
    assert_equal('%:"a capturing symbol"', @atom.inspect)
  end
  include ShouldBeACapturingAtom
end

class TestTrueClassToRegularAtom < Test::Unit::TestCase
  def setup
    @atom = true.to_atom
  end
  include ShouldBeARegularAtom
end

class TestTrueClassToCapturingAtom < Test::Unit::TestCase
  def setup
    @atom = true.to_atom(false)
  end
  include ShouldBeACapturingAtom
end  

class TestFalseClassToRegularAtom < Test::Unit::TestCase
  def setup
    @atom = false.to_atom
  end
  include ShouldBeARegularAtom
end

class TestFalseClassToCapturingAtom < Test::Unit::TestCase
  def setup
    @atom = false.to_atom(false)
  end
  include ShouldBeACapturingAtom
end  

class TestNilClassToRegularAtom < Test::Unit::TestCase
  def setup
    @atom = nil.to_atom
  end
  include ShouldBeARegularAtom
end

class TestNilClassToCapturingAtom < Test::Unit::TestCase
  def setup
    @atom = nil.to_atom(false)
  end
  include ShouldBeACapturingAtom
end  

# --------------------

class TestAttemptBuildingAtomFromArray < Test::Unit::TestCase
  def setup
    @attempted_contents = [:this, :should, :not, :work] 
  end
  include ShouldNotBeConvertibleToAtom
end

class TestAttemptBuildingAtomFromHash < Test::Unit::TestCase
  def setup
    @attempted_contents = {:this => "should not work"}
  end
  include ShouldNotBeConvertibleToAtom
end

# --------------------

class TestRegularIntegerMatch < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(50)
  end
  def test_should_match_same_integer
    assert(@atom.match?(50.to_atom))
  end
  def test_should_not_match_different_integer
    assert_equal(false, @atom.match?(5.to_atom))
    assert_equal(false, @atom.match?(500.to_atom))
  end
  include ShouldNotMatchAnyString
  include ShouldNotMatchAnySymbol
  include ShouldBeARegularAtom
end

class TestCapturingIntegerMatch < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(50, true)
  end
  include ShouldMatchAnyInteger
  include ShouldNotMatchAnyString
  include ShouldNotMatchAnySymbol
  include ShouldBeACapturingAtom
end

class TestRegularStringMatch < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new("david")
  end
  def test_should_match_same_string
    assert(@atom.match?("david".to_atom))
  end
  def test_should_not_match_different_string
    assert(@atom.match?("david".to_atom))
  end
  include ShouldBeARegularAtom
  include ShouldNotMatchAnyInteger
  include ShouldNotMatchAnySymbol
end

class TestCapturingStringMatch < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new("label", true)
  end
  include ShouldBeACapturingAtom
  include ShouldMatchAnyString
  include ShouldNotMatchAnyInteger
  include ShouldNotMatchAnySymbol
end

class TestRegularSymbolMatch < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(:cymbal)
  end
  def test_should_match_same_symbol
    assert(@atom.match?(:cymbal.to_atom))
  end
  def test_should_not_match_different_symbol
    assert_equal(false, @atom.match?(:timpani.to_atom))
    assert_equal(false, @atom.match?(:xylophone.to_atom))
  end
  include ShouldBeARegularAtom
  include ShouldNotMatchAnyInteger
  include ShouldNotMatchAnyString
end

class TestCapturingSymbolMatch < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(:cymbal, true)
  end
  include ShouldBeACapturingAtom
  include ShouldMatchAnySymbol
  include ShouldNotMatchAnyInteger
  include ShouldNotMatchAnyString
end

# --------------------

class TestRegularIntegerCapture < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(23)
    @attempted_capture = 30.to_atom
  end
  include ShouldRaiseExceptionWhenAttemptingCapture
  include ShouldReturnNilFromTryCapture
end

class TestRegularStringCapture < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new("string")
    @attempted_capture = "string".to_atom
  end
  include ShouldRaiseExceptionWhenAttemptingCapture
  include ShouldReturnNilFromTryCapture
end

class TestRegularSymbolCapture < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(:symbol)
    @attempted_capture = :symbol.to_atom
  end
  include ShouldRaiseExceptionWhenAttemptingCapture
  include ShouldReturnNilFromTryCapture
end

class TestCapturingIntegerCapture < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(23, true)
  end
  def test_capturing_integer_should_succeed
    assert_equal(40, @atom.capture(40.to_atom))
  end
  def test_capturing_string_should_fail
    assert_equal(nil, @atom.capture("cheese".to_atom))
  end
  def test_capturing_symbol_should_fail
    assert_equal(nil, @atom.capture(:tejas_club.to_atom))
  end
  def test_try_capture_integer_should_succeed
    assert_equal(40, @atom.try_capture(40.to_atom))
  end
  def test_try_capture_string_should_fail
    assert_equal(nil, @atom.try_capture("string".to_atom))
  end
  def test_try_capture_symbol_should_fail
    assert_equal(nil, @atom.try_capture(:symbol.to_atom))
  end
end

class TestCapturingStringCapture < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new("string", true)
  end
  def test_capturing_integer_should_fail
    assert_equal(nil, @atom.capture(40.to_atom))
  end
  def test_capturing_string_should_succeed
    assert_equal("cheese", @atom.capture("cheese".to_atom))
  end
  def test_capturing_symbol_should_fail
    assert_equal(nil, @atom.capture(:tejas_club.to_atom))
  end
  def test_try_capture_integer_should_fail
    assert_equal(nil, @atom.try_capture(40.to_atom))
  end
  def test_try_capture_string_should_succeed
    assert_equal("cheese", @atom.try_capture("cheese".to_atom))
  end
  def test_try_capture_symbol_should_fail
    assert_equal(nil, @atom.try_capture(:symbol.to_atom))
  end
end

class TestCapturingSymbolCapture < Test::Unit::TestCase
  def setup
    @atom = MethodTrails::Atom.new(:symbol, true)
  end
  def test_capturing_integer_should_fail
    assert_equal(nil, @atom.capture(40.to_atom))
  end
  def test_capturing_string_should_fail
    assert_equal(nil, @atom.capture("cheese".to_atom))
  end
  def test_capturing_symbol_should_succeed
    assert_equal(:tejas_club, @atom.capture(:tejas_club.to_atom))
  end
  def test_try_capture_integer_should_fail
    assert_equal(nil, @atom.try_capture(40.to_atom))
  end
  def test_try_capture_string_should_fail
    assert_equal(nil, @atom.try_capture("cheese".to_atom))
  end
  def test_try_capture_symbol_should_succeed
    assert_equal(:symbol, @atom.try_capture(:symbol.to_atom))
  end
end
