require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestGeneralSibling_RegStrA_CapStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__general_sibling, ["a", "%b"]])
  end
  def test_simplest_match
    @subject =
    [ "a",
      "any"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_siblings_need_not_be_adjacent_to_match
    @subject =
    [ "a",
      :extra,
      "any"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_siblings_can_be_separated_by_nested_array
    @subject =
    [ "a",
      [ "nested" ],
      "any"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_different_older_sibling_so_no_match
    @subject =
    [ "a_different",
      "b"
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
  def test_duplicate_older_sibling_means_3_matches
    @subject =
    [ "a",
      "a",
      "any"
    ].to_s_exp
    assert_equal(3, @rule.matches(@subject))
    assert_equal({ "b" => ["a", "any", "any"] }, @rule.captured)
  end
  def test_duplicate_younger_sibling_means_2_matches
    @subject =
    [ "a",
      "any",
      "any"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any", "any"] }, @rule.captured)
  end
  def test_duplicate_sibling_pair_leads_to_4_matches
    @subject =
    [ "a",
      "any",
      "a",
      "any"
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    assert_equal({ "b" => ["any", "a", "any", "any"] }, @rule.captured)
  end
  def test_duplicating_both_siblings_leads_to_5_matches
    @subject =
    [ "a",
      "a",
      "any",
      "any"
    ].to_s_exp
    assert_equal(5, @rule.matches(@subject))
    assert_equal({ "b" => ["a", "any", "any", "any", "any"] }, @rule.captured)
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
    [ :noise1,
      :noise2,
      "a",
      "any",
      :noise3,
      :noise4
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
end
