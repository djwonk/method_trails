module ShouldBehaveLikeChild_CapStrA_RegStrB_RegStrC
  def test_simplest_match
    @subject = 
    [ "any",
      [ "b",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_parent_different_so_no_match
    @subject = 
    [ :different_parent,
      [ "b",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_child_different_so_no_match
    @subject = 
    [ "any",
      [ "different_child",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_grandchild_different_so_no_match
    @subject = 
    [ "any",
      [ "b",
        [ "different_grandchild" ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_extra_older_parent_still_1_match
    @subject =
    [ "any_older",
      "any",
      [ "b",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_parent_still_1_match
    @subject =
    [ "any",
      [ "b",
        [ "c" ]
      ],
      "any_younger"
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_older_child_still_1_match
    @subject =
    [ "any",
      [ "b_older",
        "b",
        [ "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_child_still_1_match
    @subject = 
    [ "any",
      [ "b",
        [ "c" ],
        "b_younger"
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_older_grandchild_still_1_match
    @subject = 
    [ "any",
      [ "b",
        [ "c_older", "c" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_extra_younger_grandchild_still_1_match
    @subject = 
    [ "any",
      [ "b",
        [ "c", "c_younger" ]
      ]
    ].to_s_exp
    assert_equal(1, @rule.matches(@subject))
    assert_equal({ "a" => ["any"] }, @rule.captured)
  end
  def test_parent_too_far_down_to_match
    @subject = 
    [ "extra",
      [ "any",
        [ "b",
          [ "c" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_child_too_far_down_to_match
    @subject = 
    [ "any",
      [ "extra",
        [ "b",
          [ "c" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
  def test_grandchild_too_far_down_to_match
    @subject = 
    [ "any",
      [ "b",
        [ "extra",
          [ "c" ]
        ]
      ]
    ].to_s_exp
    assert_equal(0, @rule.matches(@subject))
    assert_equal(nil, @rule.captured)
  end
end
