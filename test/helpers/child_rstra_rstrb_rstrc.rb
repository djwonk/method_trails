module ShouldBehaveLikeChild_RegStrA_RegStrB_RegStrC
  def test_simplest_match
    @subject =
    [ "a",
      [ "b",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_parent_different_so_no_match
    @subject =
    [ "different_parent",
      [ "b",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_child_different_so_no_match
    @subject =
    [ "a",
      [ "different_child",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_grandchild_different_so_no_match
    @subject =
    [ "a",
      [ "b",
        [ "different_grandchild" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def test_extra_older_parent_still_1_match
    @subject =
    [ "a_older",
      "a",
      [ "b",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_younger_parent_still_1_match
    @subject =
    [ "a",
      [ "b",
        [ "c" ]
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
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_younger_child_still_1_match
    @subject =
    [ "a",
      [ "b",
        [ "c" ],
        "b_younger"
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_older_grandchild_still_1_match
    @subject =
    [ "a",
      [ "b",
        [ "c_older", "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_extra_younger_grandchild_still_1_match
    @subject =
    [ "a",
      [ "b",
        [ "c", "c_younger" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
  end
  def test_parent_too_far_down_to_match
    @subject =
    [ "extra",
      [ "a",
        [ "b",
          [ "c" ]
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
          [ "c" ]
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
          [ "c" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
