require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestChild_RegStrA_CapStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__child, ["a", "%b"]])
  end
  def test_simplest_match
    @subject =
    [ "a",
      [ "any" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_duplicate_parent_and_child_so_2_matches
    @subject =
    [ "a",
      [ "any1" ],
      "a",
      [ "any2" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any1", "any2"] }, @rule.captured)
    assert_match_head_index_equals([0, 2])
    assert_match_tail_index_equals([0, 0])
  end
  def test_duplicate_child_so_2_matches
    @subject =
    [ "a",
      [ "any1", "any2" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any1", "any2"] }, @rule.captured)
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 1])
  end
  def test_parent_different_so_no_match
    @subject =
    [ "different_parent",
      [ "any" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_child_different_so_no_match
    @subject =
    [ "a",
      [ :different ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_extra_older_parent_still_1_match
    @subject =
    [ "a_older",
      "a",
      [ "any" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([1])
    assert_match_tail_index_equals([0])
  end
  def test_extra_younger_parent_still_1_match
    @subject =
    [ "a",
      [ "any" ],
      "a_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_extra_older_child_still_1_match
    @subject =
    [ "a",
      [ :older, "any" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1])
  end
  def test_extra_younger_child_still_1_match
    @subject =
    [ "a",
      [ "any", :younger ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_child_too_far_down_to_match
    @subject =
    [ "a",
      [ :extra,
        [ "any" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_parent_too_far_down_to_match
    @subject =
    [ "extra",
      [ "a",
        [ "any" ]
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
      [ "b" ],
      "noise3",
      "noise4"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["b"] }, @rule.captured)
    assert_match_head_index_equals([2])
    assert_match_tail_index_equals([0])
  end
end
