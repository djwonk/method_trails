require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'
require_relative '/../../../lib/classes/match'

class TestAtom_RegStr < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(["a"])
  end
  def test_should_match_identical_string_1_time
    @subject = ["a"].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_should_not_match_similar_symbol
    @subject = [:a].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_should_match_2_identical_strings_2_times
    @subject = ["a", "diff", "a"].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 2])
    assert_match_tail_index_equals([0, 2])
  end
  def test_should_not_match_different_string
    @subject = ["diff"].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_should_only_match_the_top_level_string
    @subject = ["a", ["a", "a", "diff"]].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_should_match_2_top_level_strings_2_times
    @subject = ["a", ["a", "a", "diff"], "a"].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 2])
    assert_match_tail_index_equals([0, 2])
  end
  def test_should_not_match_children
    @subject = ["diff", ["diff", "a"]].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end


