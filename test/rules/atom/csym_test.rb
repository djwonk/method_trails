require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestAtom_CapSym < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:"%a"])
  end
  def test_should_match_identical_symbol_1_time
    @subject = [:any].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ :a => [:any] }, @rule.captured)
  end
  def test_should_not_match_similar_string
    @subject = ["a"].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_should_match_3_strings_3_times
    @subject = [:any1, :any2, :any3].to_s_exp
    assert_equal(3, @rule.matches(@subject))
    assert_equal({ :a => [:any1, :any2, :any3] }, @rule.captured)
  end
  def test_should_match_any_string
    @subject = [:any].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ :a => [:any] }, @rule.captured)
  end
  def test_should_only_match_the_top_level_string
    @subject = [:any1, [:any2, :any3, :any4]].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ :a => [:any1] }, @rule.captured)
  end
  def test_should_match_2_top_level_strings_2_times
    @subject = [:any1, [:any2, :any3, :any4], :any5].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ :a => [:any1, :any5] }, @rule.captured)
  end
  def test_should_not_match_symbols
    @subject = [:any1, "any2", "any3", :any4, "any5"].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ :a => [:any1, :any4] }, @rule.captured)
  end
end
