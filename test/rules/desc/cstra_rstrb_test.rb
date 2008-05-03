require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestDescendant_CapStrA_RegStrB < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__descendant, ["%a", "b"]])
  end
  def test_child_match
    @subject = 
    [ "any",
      [ "b" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_grandchild_match
    @subject = 
    [ "any",
      [ :extra,
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_great_grandchild_match
    @subject = 
    [ "any",
      [ :extra,
        [ :extra,
          [ "b" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_duplicate_parent_and_child_so_2_matches
    @subject = 
    [ "any1",
      [ "b" ],
      "any2",
      [ "b" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any1", "any2"] }, @rule.captured)
  end
  def test_duplicate_parent_and_grandchild_so_2_matches
    @subject = 
    [ "any1",
      [ :extra,
        [ "b" ]
      ],
      "any2",
      [ :extra,
        [ "b" ]
      ],
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any1", "any2"] }, @rule.captured)
  end
  def test_duplicate_child_so_2_matches
    @subject = 
    [ "any",
      [ "b", "b" ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any", "any"] }, @rule.captured)
  end
  def test_duplicate_grandchild_through_common_child_so_2_matches
    @subject = 
    [ "any",
      [ :extra,
        [ "b", "b" ]
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any", "any"] }, @rule.captured)
  end
  def test_duplicate_grandchild_through_different_children_so_2_matches
    @subject = 
    [ "any",
      [ :extra,
        [ "b" ]
      ],
      [ :extra,
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "a" => ["any", "any"] }, @rule.captured)
  end
  def test_parent_different_so_no_match_with_child
    @subject = 
    [ :different_parent,
      [ "b" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_parent_different_so_no_match_with_grandchild
    @subject = 
    [ :different_parent,
      [ :extra,
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_child_different_so_no_match
    @subject = 
    [ "any",
      [ "different_child" ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_grandchild_different_so_no_match
    @subject = 
    [ "any",
      [ :extra,
        [ "different_child" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_extra_older_parent_still_1_match_with_child
    @subject = 
    [ "any_older",
      "any",
      [ "b" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_older_parent_still_1_match_with_grandchild
    @subject = 
    [ "any_older",
      "any",
      [ :extra,
        [ "b" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_parent_still_1_match_with_child
    @subject = 
    [ "any",
      [ "b" ],
      "any_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_parent_still_1_match_with_grandchild
    @subject = 
    [ "any",
      [ :extra,
        [ "b" ],
      ],
      "any_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_older_child_still_1_match_with_child
    @subject = 
    [ "any",
      [ "b_older", "b" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_older_grandchild_still_1_match_with_grandchild
    @subject = 
    [ "any",
      [ :extra,
        [ "b_older", "b" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_child_still_1_match_with_child
    @subject = 
    [ "any",
      [ "b", "b_younger" ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_grandchild_still_1_match_with_grandchild
    @subject = 
    [ "any",
      [ :extra,
        [ "b", "b_younger" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_parent_too_far_down_to_match
    @subject =
    [ :extra,
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
  end
end
