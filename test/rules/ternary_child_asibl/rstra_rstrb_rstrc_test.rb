require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestTernaryChildAdjacentSibling_RegStrA_RegStrB_RegStrC < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([[:__child, :__adjacent_sibling], ["a", "b", "c"]])
    # Intended to be the same as:
    # [:__child, ["a", "b"]] AND [:__adjacent_sibling, ["a", "c"]]
    # Where "a" is guaranteed to be the exact same atom
  end
  def test_simple_match
    @subject =
    [ "a",
      [ "b" ],
      "c"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_older_sibling_does_not_match
    @subject =
    [ "c",
      "a",
      [ "b" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    # Adjacent (and general) siblings are only found looking forward
  end
  def test_mismatch_with_parent
    @subject =
    [ "a_other",
      [ "b" ],
      "c"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_mismatch_with_child
    @subject =
    [ "a",
      [ "b_other" ],
      "c"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_mismatch_with_adjacent_sibling
    @subject =
    [ "a",
      [ "b" ],
      "c_other"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_older_child_still_1_match
    @subject =
    [ "a",
      [ "b_older",
        "b"
      ],
      "c"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_extra_younger_child_still_1_match
    @subject =
    [ "a",
      [ "b",
        "b_younger"
      ],
      "c"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_extra_older_sibling_so_no_match
    @subject =
    [ "a",
      [ "b" ],
      "c_older",
      "c"
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_younger_sibling_still_1_match
    @subject =
    [ "a",
      [ "b" ],
      "c",
      "c_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_parent_too_far_down_so_no_match
    @subject =
    [ "extra",
      [ "a",
        [ "b" ],
        "c"
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_match_among_noise
    @subject =
    [ "noise1",
      "a",
      [
        "noise2",
        "b",
        "noise3"
      ],
      "c",
      "noise4",
      "noise5",
      "noise6"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([1])
    assert_match_tail_index_equals([0])
  end
  def test_side_by_side_duplicates_so_2_matches
    @subject =
    [ "a",
      [ "b" ],
      "c",
      "a",
      [ "b" ],
      "c"
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 3])
    assert_match_tail_index_equals([0, 0])
  end
  def test_intermingled_duplicates_only_1_match
    @subject =
    [ "a",
      [ "b" ],
      "a",
      [ "b" ],
      "c",
      "c"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([2])
    assert_match_tail_index_equals([0])
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
