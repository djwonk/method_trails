require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestAdjacentSibling_RegStrA_CapStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__adjacent_sibling, ["a", "%b"]])
  end
  def test_simplest_match
    @subject =
    [ "a",
      "any"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_siblings_must_be_adjacent_to_match
    @subject =
    [ "a",
      :extra,
      "any"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_different_older_sibling_so_no_match
    @subject =
    [ "a_different",
      "any"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_different_younger_sibling_so_no_match
    @subject =
    [ "a",
      :b_different
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_duplicate_older_sibling_now_2_matches
    @subject =
    [ "a",
      "a",
      "any"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["a", "any"] }, @rule.captured)
  end
  def test_duplicate_younger_sibling_so_2_matches
    @subject =
    [ "a",
      "any1",
      "any2"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any1"] }, @rule.captured)
  end
  def test_duplicate_sibling_pair_so_2_matches
    @subject =
    [ "a",
      "any1",
      "a",
      "any2"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any1", "any2"] }, @rule.captured)
  end
  def test_duplicating_both_siblings_still_1_match
    @subject =
    [ "a",
      "a",
      "any1",
      "any2"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["a", "any1"] }, @rule.captured)
  end
  def test_siblings_too_far_down_to_match
    @subject =
    [ "extra",
      [ "a",
        "any"
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_match_among_noise
    @subject =
    [ "noise1",
      "noise2",
      "a",
      "any",
      "noise3",
      "noise4"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
end
