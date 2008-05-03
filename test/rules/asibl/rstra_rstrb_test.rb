require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestAdjacentSibling_RegStrA_RegStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__adjacent_sibling, ["a", "b"]])
  end
  def test_simplest_match
    @subject = 
    [ "a",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0]) 
  end
  def test_siblings_must_be_adjacent_to_match
    @subject =
    [ "a",
      "extra",
      "b"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_different_older_sibling_so_no_match
    @subject = 
    [ "a_different",
      "b"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_different_younger_sibling_so_no_match
    @subject = 
    [ "a",
      "b_different"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_duplicate_older_sibling_still_1_match
    @subject = 
    [ "a",
      "a",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([1])
    assert_match_tail_index_equals([0]) 
  end
  def test_duplicate_younger_sibling_still_1_match
    @subject = 
    [ "a",
      "b",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0]) 
  end
  def test_duplicate_sibling_pair_so_2_matches
    @subject = 
    [ "a",
      "b",
      "a",
      "b"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 2])
    assert_match_tail_index_equals([0, 0]) 
  end
  def test_duplicating_both_siblings_still_1_match
    @subject = 
    [ "a",
      "a",
      "b",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([1])
    assert_match_tail_index_equals([0]) 
  end
  def test_siblings_too_far_down_to_match
    @subject =
    [ "extra",
      [ "a",
        "b"
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_match_among_noise
    @subject = 
    [ "noise1",
      "noise2",
      "a",
      "b",
      "noise3",
      "noise4"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([2])
    assert_match_tail_index_equals([0]) 
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
