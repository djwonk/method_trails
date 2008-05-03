require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestTernaryChildAdjacentSiblingWithRightchild_RegStrA_RegStrB_RegStrC_RegStrD < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
      [
        [ :__child,
          :__adjacent_sibling
        ],
        [ :a, 
          [ :__child,
            [ :b,
              "%l"
            ]
          ],
          [ :__child,
            [ :n,
              [ :__child,
                [ :o,
                  "%r"
                ]
              ]
            ]
          ]
        ]
      ]
    )
  end
  def test_simplest_match
    @subject = 
    [ :a,
      [ :b,
        [ "c1" ]
      ],
      :n,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "l" => ["c1"], "r" => ["p1"] }, @rule.captured)
  end
  def test_parent_mismatch
    @subject = 
    [ :a_wrong,
      [ :b,
        [ "c1" ]
      ],
      :n,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_child_mismatch
    @subject = 
    [ :a,
      [ :b_wrong,
        [ "c1" ]
      ],
      :n,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_grandchild_mismatch
    @subject = 
    [ :a,
      [ :b,
        [ :c_wrong ]
      ],
      :n,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_sibling_mismatch
    @subject = 
    [ :a,
      [ :b,
        [ "c1" ]
      ],
      :n_wrong,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  # def test_ruin_sibling_adjacency_so_mismatch
  #   @subject = 
  #   [ :a,
  #     [ :b,
  #       [ "c1" ]
  #     ],
  #     "extra",
  #     :n,
  #     [ :o,
  #       [ "p1" ]
  #     ]
  #   ].to_s_exp
  #   assert_equal(0, @rule.matches(@subject)) # FAILS w/ 1
  #   assert_equal(nil, @rule.captured)
  # end
  def test_sibling_child_mismatch
    @subject = 
    [ :a,
      [ :b,
        [ "c1" ]
      ],
      :n,
      [ :o_wrong,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_sibling_grandchild_mismatch
    @subject = 
    [ :a,
      [ :b,
        [ "c1" ]
      ],
      :n,
      [ :o,
        [ :p_wrong ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_2x_grandchild_so_2_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1", "c2" ]
      ],
      :n,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "l" => %w(c1 c2), "r" => %w(p1 p1) }, @rule.captured)
  end
  def test_3x_grandchild_so_3_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1", "c2", "c3" ]
      ],
      :n,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(3, @rule.matches(@subject))
    assert_equal({ "l" => %w(c1 c2 c3), "r" => %w(p1 p1 p1) }, @rule.captured)
  end
  def test_4x_grandchild_so_4_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1", "c2", "c3", "c4" ]
      ],
      :n,
      [ :o,
        [ "p1" ]
      ]
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    assert_equal({ "l" => %w(c1 c2 c3 c4), "r" => %w(p1 p1 p1 p1) }, @rule.captured)
  end
  def test_2x_sibling_grandchild_so_2_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1" ]
      ],
      :n,
      [ :o,
        [ "p1", "p2" ]
      ]
    ].to_s_exp
    assert_equal(2, @rule.matches(@subject))
    assert_equal({ "l" => %w(c1 c1), "r" => %w(p1 p2) }, @rule.captured)
  end
  def test_3x_sibling_grandchild_so_3_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1" ]
      ],
      :n,
      [ :o,
        [ "p1", "p2", "p3" ]
      ]
    ].to_s_exp
    assert_equal(3, @rule.matches(@subject))
    assert_equal({ "l" => %w(c1 c1 c1), "r" => %w(p1 p2 p3) }, @rule.captured)
  end
  def test_4x_sibling_grandchild_so_4_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1" ]
      ],
      :n,
      [ :o,
        [ "p1", "p2", "p3", "p4" ]
      ]
    ].to_s_exp
    assert_equal(4, @rule.matches(@subject))
    assert_equal({ "l" => %w(c1 c1 c1 c1), "r" => %w(p1 p2 p3 p4) }, @rule.captured)
  end
  def test_2x_grandchild_3x_sibling_grandchild_so_6_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1", "c2" ]
      ],
      :n,
      [ :o,
        [ "p1", "p2", "p3" ]
      ]
    ].to_s_exp
    assert_equal(6, @rule.matches(@subject))
    cap = {}
    cap["l"] = %w(c1 c1 c1 c2 c2 c2)
    cap["r"] = %w(p1 p2 p3 p1 p2 p3)
    assert_equal(cap, @rule.captured)
  end
  def test_3x_grandchild_2x_sibling_grandchild_so_6_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1", "c2", "c3" ]
      ],
      :n,
      [ :o,
        [ "p1", "p2" ]
      ]
    ].to_s_exp
    assert_equal(6, @rule.matches(@subject))
    cap = {}
    cap["l"] = %w(c1 c1 c2 c2 c3 c3)
    cap["r"] = %w(p1 p2 p1 p2 p1 p2)
    assert_equal(cap, @rule.captured)
  end
  def test_3x_grandchild_3x_sibling_grandchild_so_9_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1", "c2", "c3" ]
      ],
      :n,
      [ :o,
        [ "p1", "p2", "p3" ]
      ]
    ].to_s_exp
    assert_equal(9, @rule.matches(@subject))
    cap = {}
    cap["l"] = %w(c1 c1 c1 c2 c2 c2 c3 c3 c3)
    cap["r"] = %w(p1 p2 p3 p1 p2 p3 p1 p2 p3)
    assert_equal(cap, @rule.captured)
  end
  def test_noisy_3x_left_3x_right_so_9_matches
    @subject = 
    [ :a,
      [ :b,
        [ "c1", :noise_1, "c2" ],
        :b,
        [ "c3"],
        "noise_2"
      ],
      :n,
      [ :o,
        [ "p1" ],
        :noise_3,
        :o,
        [ :noise_4,
          "p2",
          :noise_5 ],
        :noise_6,
        "noise_7",
        [ "noise_8",
          "noise_9" ],
        :o,
        [ "p3" ]
      ]
    ].to_s_exp
    assert_equal(9, @rule.matches(@subject))
    cap = {}
    cap["l"] = %w(c1 c1 c1 c2 c2 c2 c3 c3 c3)
    cap["r"] = %w(p1 p2 p3 p1 p2 p3 p1 p2 p3)
    assert_equal(cap, @rule.captured)
  end
end
