module ShouldBehaveLikeChild_RegStrA_RegStrB_RegStrC_RegStrD
  def test_simplest_match
    @subject = 
    [ "a",
      [ "b",
        [ "c",
          [ "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_parent_different_so_no_match
    @subject = 
    [ "different_parent",
      [ "b",
        [ "c",
          [ "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_child_different_so_no_match
    @subject = 
    [ "a",
      [ "different_child",
        [ "c",
          [ "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_grandchild_different_so_no_match
    @subject = 
    [ "a",
      [ "b",
        [ "different_grandchild",
          [ "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_great_grandchild_different_so_no_match
    @subject = 
    [ "a",
      [ "b",
        [ "c",
          [ "different_great_grandchild" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_older_parent_still_1_match
    @subject =
    [ "a_older",
      "a",
      [ "b",
        [ "c",
          [ "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_younger_parent_still_1_match
    @subject =
    [ "a",
      [ "b",
        [ "c",
          [ "d" ]
        ]
      ],
      "a_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_older_child_still_1_match
    @subject =
    [ "a",
      [ "b_older",
        "b",
        [ "c",
          [ "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_younger_child_still_1_match
    @subject = 
    [ "a",
      [ "b",
        [ "c",
          [ "d" ]
        ],
        "b_younger"
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_older_grandchild_still_1_match
    @subject = 
    [ "a",
      [ "b",
        [ "c_older",
          "c",
          [ "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_younger_grandchild_still_1_match
    @subject = 
    [ "a",
      [ "b",
        [ "c",
          [ "d" ],
          "c_younger"
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_older_great_grandchild_still_1_match
    @subject = 
    [ "a",
      [ "b",
        [ "c",
          [ "d_older", "d" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_younger_great_grandchild_still_1_match
    @subject = 
    [ "a",
      [ "b",
        [ "c",
          [ "d", "d_younger" ]
        ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_parent_too_far_down_to_match
    @subject = 
    [ "extra",
      [ "a",
        [ "b",
          [ "c",
            [ "d" ]
          ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_child_too_far_down_to_match
    @subject = 
    [ "a",
      [ "extra",
        [ "b",
          [ "c",
            [ "d" ]
          ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_grandchild_too_far_down_to_match
    @subject = 
    [ "a",
      [ "b",
        [ "extra",
          [ "c",
            [ "d" ]
          ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_great_grandchild_too_far_down_to_match
    @subject = 
    [ "a",
      [ "b",
        [ "c",
          [ "extra",
            [ "d" ]
          ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
