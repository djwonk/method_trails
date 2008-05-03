require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestDescendant_RegStrA_RegStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__descendant, ["a", "b"]])
  end
  def test_child_match
    @subject = 
    [ "a",
      [ "b" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_grandchild_match
    @subject = 
    [ "a",
      [ "extra",
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_great_grandchild_match
    @subject = 
    [ "a",
      [ "extra",
        [ "extra",
          [ "b" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_duplicate_parent_and_child_so_2_matches
    @subject = 
    [ "a",
      [ "b" ],
      "a",
      [ "b" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 2])
    assert_match_tail_index_equals([0, 0])
  end
  def test_duplicate_parent_and_grandchild_so_2_matches
    @subject = 
    [ "a",
      [ "extra",
        [ "b" ]
      ],
      "a",
      [ "extra",
        [ "b" ]
      ],
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 2])
    assert_match_tail_index_equals([0, 0])
  end
  def test_duplicate_child_so_2_matches
    @subject = 
    [ "a",
      [ "b", "b" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 1])
  end
  def test_duplicate_grandchild_through_common_child_so_2_matches
    @subject = 
    [ "a",
      [ "extra",
        [ "b", "b" ]
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 1])
  end
  def test_duplicate_grandchild_through_different_children_so_2_matches
    @subject = 
    [ "a",
      [ "extra",
        [ "b" ]
      ],
      [ "extra",
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_match_head_index_equals([0, 0])
    assert_match_tail_index_equals([0, 0])
  end
  def test_parent_different_so_no_match_with_child
    @subject = 
    [ "different_parent",
      [ "b" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_parent_different_so_no_match_with_grandchild
    @subject = 
    [ "different_parent",
      [ "extra",
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_child_different_so_no_match
    @subject = 
    [ "a",
      [ "different_child" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_grandchild_different_so_no_match
    @subject = 
    [ "a",
      [ "extra",
        [ "different_child" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_older_parent_still_1_match_with_child
    @subject = 
    [ "a_older",
      "a",
      [ "b" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([1])
    assert_match_tail_index_equals([0])
  end
  def test_extra_older_parent_still_1_match_with_grandchild
    @subject = 
    [ "a_older",
      "a",
      [ "extra",
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([1])
    assert_match_tail_index_equals([0])
  end
  def test_extra_younger_parent_still_1_match_with_child
    @subject = 
    [ "a",
      [ "b" ],
      "a_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_extra_younger_parent_still_1_match_with_grandchild
    @subject = 
    [ "a",
      [ "extra",
        [ "b" ],
      ],
      "a_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_extra_older_child_still_1_match_with_child
    @subject = 
    [ "a",
      [ "b_older", "b" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1])
  end
  def test_extra_older_grandchild_still_1_match_with_grandchild
    @subject = 
    [ "a",
      [ "extra",
        [ "b_older", "b" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1])
  end
  def test_extra_younger_child_still_1_match_with_child
    @subject = 
    [ "a",
      [ "b", "b_younger" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_extra_younger_grandchild_still_1_match_with_grandchild
    @subject = 
    [ "a",
      [ "extra",
        [ "b", "b_younger" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([0])
  end
  def test_parent_too_far_down_to_match
    @subject =
    [ "extra",
      [ "a",
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
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
    assert_match_head_index_equals([2])
    assert_match_tail_index_equals([0])
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
