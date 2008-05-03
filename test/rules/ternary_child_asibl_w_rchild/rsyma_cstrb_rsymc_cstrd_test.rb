require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestTernaryChildAdjacentSiblingWithRightChild_RegSymA_CapStrB_RegSymC_CapStrD < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
      [
        [ :__child,
          :__adjacent_sibling
        ],
        [ :a, 
          "%b",
          [ :__child,
            [:c, "%d"]
          ]
        ]
      ]
    )
  end
  def test_simple_match
    @subject = 
    [ :a,
      [ "b1" ],
      :c,
      [ "d1" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["b1"], "d" => ["d1"] }, @rule.captured)
    # assert_match_head_index_equals([0])
    # assert_match_tail_index_equals([0])
  end
  def test_mismatch_due_to_parent
    @subject = 
    [ :a_different,
      [ "b1" ],
      :c,
      [ "d1" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_mismatch_due_to_1st_child
    @subject = 
    [ :a,
      [ :b_different ],
      :c,
      [ "d1" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_mismatch_due_to_sibling
    @subject = 
    [ :a,
      [ "b1" ],
      :c_different,
      [ "d1" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_mismatch_due_to_2nd_child
    @subject = 
    [ :a,
      [ "b1" ],
      :c,
      [ :d_different ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_duplicate_1st_child_so_2_matches
    @subject = 
    [ :a,
      [ "b1", "b2" ],
      :c,
      [ "d1" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b2)
    cap["d"] = %w(d1 d1)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0])
    # assert_match_tail_index_equals([0, 0])
  end
  def test_duplicate_2nd_child_so_2_matches
    @subject = 
    [ :a,
      [ "b1" ],
      :c,
      [ "d1", "d2" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b1)
    cap["d"] = %w(d1 d2)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0])
    # assert_match_tail_index_equals([0, 1])
  end
  def test_triplicate_1st_child_so_3_matches
    @subject = 
    [ :a,
      [ "b1", "b2", "b3" ],
      :c,
      [ "d1" ]
    ].to_s_exp
    assert_equal(3, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b2 b3)
    cap["d"] = %w(d1 d1 d1)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0])
    # assert_match_tail_index_equals([0, 0])
  end
  def test_triplicate_2nd_child_so_3_matches
    @subject = 
    [ :a,
      [ "b1" ],
      :c,
      [ "d1", "d2", "d3" ]
    ].to_s_exp
    assert_equal(3, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b1 b1)
    cap["d"] = %w(d1 d2 d3)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0])
    # assert_match_tail_index_equals([0, 1])
  end
  def test_4x_1st_child_so_4_matches
    @subject = 
    [ :a,
      [ "b1", "b2", "b3", "b4" ],
      :c,
      [ "d1" ]
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b2 b3 b4)
    cap["d"] = %w(d1 d1 d1 d1)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0])
    # assert_match_tail_index_equals([0, 0])
  end
  def test_4x_2nd_child_so_4_matches
    @subject = 
    [ :a,
      [ "b1" ],
      :c,
      [ "d1", "d2", "d3", "d4" ]
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b1 b1 b1)
    cap["d"] = %w(d1 d2 d3 d4)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0])
    # assert_match_tail_index_equals([0, 1])
  end
  def test_duplicate_1st_and_2nd_children_so_4_matches
    @subject = 
    [ :a,
      [ "b1", "b2" ],
      :c,
      [ "d1", "d2" ]
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b1 b2 b2)
    cap["d"] = %w(d1 d2 d1 d2)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0, 0, 0])
    # assert_match_tail_index_equals([0, 1, 0, 1])
  end
  def test_double_1st_child_triple_2nd_child_so_6_matches
    @subject = 
    [ :a,
      [ "b1", "b2" ],
      :c,
      [ "d1", "d2", "d3" ]
    ].to_s_exp
    assert_equal(6, @rule.matches(@subject))
    cap = {}
    cap["b"] = %w(b1 b1 b1 b2 b2 b2)
    cap["d"] = %w(d1 d2 d3 d1 d2 d3)
    assert_equal(cap, @rule.captured)
    # assert_match_head_index_equals([0, 0, 0, 0, 0, 0])
    # assert_match_tail_index_equals([0, 1, 2, 0, 1, 2])
  end
end
