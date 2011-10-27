require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestTernaryChild_RegStrA_CapStrB_RegSymC < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule([:__child, ["a", "%b", :c]])
  end
  def test_simplest_match_gives_2_matches
    @subject =
    [ "a",
      [ "any",
        :c
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1])
  end
  def test_simple_mismatch
    @subject =
    [ "a",
      [ "any",
        :no_match
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_extra_older_child_still_1_match
    @subject =
    [ "a",
      [ :older,
        "any",
        :c
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([2])
  end
  def test_extra_middle_child_still_2_matches
    @subject =
    [ "a",
      [ "any",
        :middle,
        :c
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([2])
  end
  def test_extra_younger_child_still_2_matches
    @subject =
    [ "a",
      [ "any",
        :c,
        :younger
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([0])
    assert_match_tail_index_equals([1])
  end
  def test_parent_too_far_down_so_no_match
    @subject =
    [ "extra",
      [ "a",
        [ "any",
          :c
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_match_among_noise_with_usual_2_matches
    @subject =
    [ "noise1",
      "noise2",
      "a",
      [ "any",
        :c
      ],
      "noise3",
      "noise4"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
    assert_match_head_index_equals([2])
    assert_match_tail_index_equals([1])
  end
  def test_duplicate_so_2_matches
    # See ternary_problem.txt
    @subject =
    [ "a",
      [ "any1",
        :c
      ],
      "a",
      [ "any2",
        :c
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject)) # FAILS with 4
    assert_equal({ "b" => ["any1", "any2"] }, @rule.captured)
    assert_match_head_index_equals([0, 2])
    assert_match_tail_index_equals([1, 1])
  end
end
