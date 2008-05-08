require 'test/unit'
require 'require_relative'
require_relative '/../../lib/classes/s_exp'

module ShouldBeAnSExp
  def test_should_be_of_s_exp_class
    assert_equal(MethodTrails::SExp, @s_exp.class)
  end
  def test_should_respond_to_s_exp?
    assert(@s_exp.respond_to?(:s_exp?))
  end
  def test_should_be_an_s_exp
    assert(@s_exp.s_exp?)
  end
  def test_should_be_valid
    assert(@s_exp.valid?)
  end
  def test_should_respond_to_atom?
    assert(@s_exp.respond_to?(:atom?))
  end
  def test_should_not_be_an_atom
    assert_equal(false, @s_exp.atom?)
  end
end

module ShouldRaiseException
  def test_should_raise_atom_exception
    assert_raise(MethodTrails::SExpException, &@attempt)
  end
end

# ====================

class TestIntegerArrayToSExp < Test::Unit::TestCase
  def setup
    @s_exp = [1, 2, 3, 4, 5].to_s_exp
  end
  include ShouldBeAnSExp
end

class TestNestedIntegerArrayToSExp < Test::Unit::TestCase
  def setup
    @s_exp = [1, [2, 3], 4, 5].to_s_exp
  end
  include ShouldBeAnSExp
end

class TestStringArrayToSExp < Test::Unit::TestCase
  def setup
    @s_exp = %w(one two three four).to_s_exp
  end
  include ShouldBeAnSExp
end

class TestNestedStringArrayToSExp < Test::Unit::TestCase
  def setup
    @s_exp = ["a", "b", ["c", "d"]].to_s_exp
  end
  include ShouldBeAnSExp
end

class TestAttemptBuildingSExpFromObject < Test::Unit::TestCase
  def setup
    # Array.new(3, 7) => [7, 7, 7]
    @attempt = lambda { MethodTrails::SExp.new(3, Object.new) }
  end
  include ShouldRaiseException
end

class TestDoublyNestedIntegerArrayToSExp < Test::Unit::TestCase
  def setup
    @s_exp = [1, [2, [3, 4], 5], 6, 7].to_s_exp
  end
  def test_that_all_internals_are_s_expressions
    assert valid_s_exp(@s_exp)
  end
  def valid_s_exp(s_exp)
    s_exp.each do |element|
      if element.s_exp?
        valid_s_exp(element)
      elsif element.atom?
        true
      else
        false
      end
    end
  end
  include ShouldBeAnSExp
end

class TestDoublyNestedSymbolArrayToSExp < Test::Unit::TestCase
  def setup
    @s_exp = [:a, [:b, [:c, :d], :e], :f, :g].to_s_exp
  end
  def test_that_all_internals_are_s_expressions
    assert valid_s_exp(@s_exp)
  end
  def valid_s_exp(s_exp)
    s_exp.each do |element|
      if element.s_exp?
        valid_s_exp(element)
      elsif element.atom?
        true
      else
        false
      end
    end
  end
  include ShouldBeAnSExp
end

class TestDisableCapturingSExp < Test::Unit::TestCase
  def setup
    @s_exp = ["%a", "%b", "%c"].to_s_exp(true)
  end
  def test_confirm_consists_of_atoms
    assert @s_exp[0].atom?
    assert @s_exp[1].atom?
    assert @s_exp[2].atom?
  end
  def test_confirm_consists_of_regular_atoms
    assert @s_exp[0].regular?
    assert @s_exp[1].regular?
    assert @s_exp[2].regular?
  end
  include ShouldBeAnSExp
end

class TestDisableCapturingNestedSExp < Test::Unit::TestCase
  def setup
    @s_exp = ["%a", ["%b", "%c"]].to_s_exp(true)
  end
  def test_confirm_consists_of_atoms
    assert @s_exp[0].atom?
    assert @s_exp[1][0].atom?
    assert @s_exp[1][1].atom?
  end
  def test_confirm_consists_of_regular_atoms
    assert @s_exp[0].regular?
    assert @s_exp[1][0].regular?
    assert @s_exp[1][1].regular?
  end
  include ShouldBeAnSExp
end
