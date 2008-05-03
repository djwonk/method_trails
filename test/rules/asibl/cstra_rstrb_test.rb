require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestAdjacentSibling_CapStrA_RegStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__adjacent_sibling, ["%a", "b"]])
  end
  def test_simplest_match
    @subject = 
    [ "any",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_siblings_must_be_adjacent_to_match
    @subject =
    [ "any",
      :extra,
      "b"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_different_older_sibling_so_no_match
    @subject = 
    [ :a_different,
      "b"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_different_younger_sibling_so_no_match
    @subject = 
    [ "any",
      "b_different"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_duplicate_older_sibling_still_1_match
    @subject = 
    [ "any_older",
      "any",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_duplicate_younger_sibling_now_2_matches
    @subject = 
    [ "any",
      "b",
      "b"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any", "b"] }, @rule.captured)
  end
  def test_duplicate_sibling_pair_so_2_matches
    @subject = 
    [ "any1",
      "b",
      "any2",
      "b"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any1", "any2"] }, @rule.captured)
  end
  def test_duplicating_both_siblings_gives_2_matches
    @subject = 
    [ "any1",
      "any2",
      "b",
      "b"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any2", "b"] }, @rule.captured)
  end
  def test_siblings_too_far_down_to_match
    @subject =
    [ "extra",
      [ "any",
        "b"
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_match_among_noise
    @subject = 
    [ "noise1",
      "noise2",
      "any",
      "b",
      "noise3",
      "noise4"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
end
