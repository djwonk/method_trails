require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestAtom_RegSym < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:a])
  end
  def test_should_match_identical_symbol_1_time
    @subject = [:a].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_should_not_match_similar_string
    @subject = ["a"].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_should_match_2_identical_symbols_2_times
    @subject = [:a, :weeds, :a].to_s_exp
    assert_equal(2, @rule.matches(@subject))
  end
  def test_should_not_match_different_symbol
    @subject = [:diff].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_should_only_match_the_top_level_symbol
    @subject = [:a, [:a, :a, :diff]].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_should_match_2_top_level_symbols_2_times
    @subject = [:a, [:a, :a, :diff], :a].to_s_exp
    assert_equal(2, @rule.matches(@subject))
  end
  def test_should_not_match_children
    @subject = [:diff, [:diff, :a]].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
