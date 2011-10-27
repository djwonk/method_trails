require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestTernaryChildAdjacentSibling_RegStrA_CapStrB_RegSymC < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([[:__child, :__adjacent_sibling], ["a", "%b", :c]])
    # Intended to be the same as:
    # [:__child, ["a", "b"]] AND [:__adjacent_sibling, ["a", :c]]
    # Where "a" is guaranteed to be the exact same atom
  end
  def test_simple_match
    @subject =
    [ "a",
      [ "any" ],
      :c
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_older_sibling_does_not_match
    @subject =
    [ :c,
      "a",
      [ "any" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    # Adjacent (and general) siblings are only found looking forward
  end
  def test_mismatch_with_parent
    @subject =
    [ "a_other",
      [ "any" ],
      :c
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_mismatch_with_child
    @subject =
    [ "a",
      [ :b_other ],
      :c
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_mismatch_with_adjacent_sibling
    @subject =
    [ "a",
      [ "any" ],
      :c_other
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_older_child_still_1_match
    @subject =
    [ "a",
      [ "any_older",
        "any"
      ],
      :c
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any_older", "any"] }, @rule.captured)
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 0])
  end
  def test_extra_younger_child_still_1_match
    @subject =
    [ "a",
      [ "any",
        "any_younger"
      ],
      :c
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any", "any_younger"] }, @rule.captured)
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 0])
  end
  def test_extra_older_sibling_so_no_match
    @subject =
    [ "a",
      [ "any" ],
      :c_older,
      :c
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_younger_sibling_still_1_match
    @subject =
    [ "a",
      [ "any" ],
      :c,
      :c_younger
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_parent_too_far_down_so_no_match
    @subject =
    [ "extra",
      [ "a",
        [ "any" ],
        :c
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_match_among_noise
    @subject =
    [ "noise1",
      "a",
      [
        :noise2,
        "any",
        :noise3
      ],
      :c,
      :noise4,
      "noise5",
      :noise6
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([1])
    assert_match_tail_index_equals([0])
  end
  def test_multiple_captures_among_noise
    @subject =
    [ "noise1",
      "a",
      [
        "any1",
        "any2",
      ],
      :c,
      :noise4,
      "noise5",
      [
        "noise6",
        "noise7"
      ],
      :noise8
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any1", "any2"] }, @rule.captured)
    assert_match_head_index_equals([1, 1])
    assert_match_tail_index_equals([0, 0])
  end
  def test_side_by_side_duplicates_so_2_matches
    @subject =
    [ "a",
      [ "any1" ],
      :c,
      "a",
      [ "any2" ],
      :c
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "b" => ["any1", "any2"] }, @rule.captured)
    assert_match_head_index_equals([0, 3])
    assert_match_tail_index_equals([0, 0])
  end
  def test_intermingled_duplicates_only_1_match
    @subject =
    [ "a",
      [ "any1" ],
      "a",
      [ "any2" ],
      :c,
      :c
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any2"] }, @rule.captured)
    assert_match_head_index_equals([2])
    assert_match_tail_index_equals([0])
  end
end
