require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestTernaryChild_RegStrA_RegStrB_RegStrC < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__child, ["a", "b", "c"]])
  end
  def test_simplest_match
    @subject = 
    [ "a",
      [ "b",
        "c"
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1])
  end
  def test_simple_mismatch
    @subject = 
    [ "a",
      [ "b",
        "no_match"
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_older_child_still_1_match
    @subject = 
    [ "a",
      [ "older",
        "b",
        "c"
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([2])
  end
  def test_extra_middle_child_still_1_match
    @subject = 
    [ "a",
      [ "b",
        "middle",
        "c"
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([2])
  end
  def test_extra_younger_child_still_1_match
    @subject = 
    [ "a",
      [ "b",
        "c",
        "younger"
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1])
  end
  def test_parent_too_far_down_so_no_match
    @subject = 
    [ "extra",
      [ "a",
        [ "b",
          "c"
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_match_among_noise
    @subject = 
    [ "noise1",
      "noise2",
      "a",
      [ "b",
        "c"
      ],
      "noise3",
      "noise4"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_match_head_index_equals([2])
    assert_match_tail_index_equals([1])
  end
  def test_duplicate_so_2_matches
    # See ternary_problem.txt
    @subject = 
    [ "a",
      [ "b",
        "c"
      ],
      "a",
      [ "b",
        "c"
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject)) 
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
