module ShouldBehaveLikeChild_RegStrA_CapStrB_RegStrC
  def test_simplest_match
    @subject = 
    [ "a",
      [ "any",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_parent_different_so_no_match
    @subject = 
    [ "different_parent",
      [ "any",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_child_different_so_no_match
    @subject = 
    [ "a",
      [ :different_child,
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_grandchild_different_so_no_match
    @subject = 
    [ "a",
      [ "any",
        [ "different_grandchild" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured) # FAILS
  end
  def test_extra_older_parent_still_1_match
    @subject =
    [ "a_older",
      "a",
      [ "any",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_parent_still_1_match
    @subject =
    [ "a",
      [ "any",
        [ "c" ]
      ],
      "a_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_extra_older_child_still_1_match
    @subject =
    [ "a",
      [ :b_older,
        "any",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_child_still_1_match
    @subject = 
    [ "a",
      [ "any",
        [ "c" ],
        :b_younger
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_extra_older_grandchild_still_1_match
    @subject = 
    [ "a",
      [ "any",
        [ "c_older", "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_grandchild_still_1_match
    @subject = 
    [ "a",
      [ "any",
        [ "c", "c_younger" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "b" => ["any"] }, @rule.captured)
  end
  def test_parent_too_far_down_to_match
    @subject = 
    [ "extra",
      [ "a",
        [ "any",
          [ "c" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_child_too_far_down_to_match
    @subject = 
    [ "a",
      [ :extra,
        [ "any",
          [ "c" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_grandchild_too_far_down_to_match
    @subject = 
    [ "a",
      [ "any",
        [ "extra",
          [ "c" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured) # FAIL
  end
end
