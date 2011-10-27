require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestTernaryChildAdjacentSiblingWithRightChild_RegStrA_RegStrB_RegStrC_RegStrD < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
      [
        [ :__child,
          :__adjacent_sibling
        ],
        [ "a",
          "b",
          [ :__child,
            ["c", "d"]
          ]
        ]
      ]
    )
    # Intended to be the same as:
    # [:__child, ["a", "b"]] AND
    # [:__adjacent_sibling, ["a", [:__child, ["c", "d"]]]]
    # Where "a" is guaranteed to be the exact same atom
  end
  def test_simple_match
    @subject =
    [ "a",
      [ "b" ],
      "c",
      [ "d" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_mismatch_due_to_parent
    @subject =
    [ "a_different",
      [ "b" ],
      "c",
      [ "d" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_mismatch_due_to_1st_child
    @subject =
    [ "a",
      [ "b_different" ],
      "c",
      [ "d" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_mismatch_due_to_sibling
    @subject =
    [ "a",
      [ "b" ],
      "c_different",
      [ "d" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_mismatch_due_to_2nd_child
    @subject =
    [ "a",
      [ "b" ],
      "c",
      [ "d_different" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_duplicate_1st_child_so_2_matches
    @subject =
    [ "a",
      [ "b", "b" ],
      "c",
      [ "d" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 0])
  end
  def test_duplicate_2nd_child_so_2_matches
    @subject =
    [ "a",
      [ "b" ],
      "c",
      [ "d", "d" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 1])
  end
  def test_duplicate_1st_and_2nd_children_so_4_matches
    @subject =
    [ "a",
      [ "b", "b" ],
      "c",
      [ "d", "d" ]
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0, 0, 0])
    assert_match_tail_index_equals([0, 1, 0, 1])
  end
  def test_double_1st_child_triple_2nd_child_so_6_matches
    @subject =
    [ "a",
      [ "b", "b" ],
      "c",
      [ "d", "d", "d" ]
    ].to_s_exp
    assert_equal(6, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0, 0, 0, 0, 0])
    assert_match_tail_index_equals([0, 1, 2, 0, 1, 2])
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
