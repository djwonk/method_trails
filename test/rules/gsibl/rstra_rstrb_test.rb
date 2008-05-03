require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestGeneralSibling_RegStrA_RegStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__general_sibling, ["a", "b"]])
  end
  def test_simplest_match
    @subject = 
    [ "a",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0]) 
    # tail_index == 0 means the 1st possible general sibling of "a"
  end
  def test_siblings_need_not_be_adjacent_to_match
    @subject =
    [ "a",
      "extra",
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1]) 
    # tail_index == 1 means the 2nd possible general sibling of "a"
  end
  def test_siblings_can_be_separated_by_nested_array
    @subject =
    [ "a",
      [ "nested" ],
      "b"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0]) 
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
  def test_duplicate_older_sibling_means_2_matches
    @subject = 
    [ "a",
      "a",
      "b"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 1])
    assert_match_tail_index_equals([1, 0]) 
  end
  def test_duplicate_younger_sibling_means_2_matches
    @subject = 
    [ "a",
      "b",
      "b"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 1]) 
  end
  def test_duplicate_sibling_pair_leads_to_3_matches
    @subject = 
    [ "a",
      "b",
      "a",
      "b"
    ].to_s_exp
    assert_equal(3, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0, 2])
    assert_match_tail_index_equals([0, 2, 0]) 
  end
  def test_duplicating_both_siblings_leads_to_4_matches
    @subject = 
    [ "a",
      "a",
      "b",
      "b"
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0, 1, 1])
    assert_match_tail_index_equals([1, 2, 0, 1]) 
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
