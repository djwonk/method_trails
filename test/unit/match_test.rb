require 'test/unit'
require 'require_relative'
require_relative '/../../lib/classes/match'
require_relative '/../../lib/classes/atom'
require_relative '/../../lib/classes/s_exp'

module MatchObjectsShouldBeEqualButDistinct
  def test_that_match_objects_are_equal
    assert_equal(@m1, @m2)
  end
  def test_that_match_objects_have_different_object_ids
    assert_not_equal(@m1.object_id, @m2.object_id)
  end
end

module MatchInternalObjectsShouldBeDistinct
  def test_that_internal_heads_are_distinct
    assert_not_equal(@m1.head_sibl.object_id, @m2.head_sibl.object_id)
  end
  def test_that_internal_tails_are_distinct
    assert_not_equal(@m1.tail_sibl.object_id, @m2.tail_sibl.object_id)
  end
  def test_that_internal_futures_are_distinct
    assert_not_equal(@m1.future.object_id, @m2.future.object_id)
  end
end

module SemanticSiblingsShouldBeCorrectFor_0_1_2_Examples
  def test_younger_semantic_siblings
    yss = [3, 4, [5, 6]].to_s_exp
    assert_equal(yss, @m.younger_semantic_siblings)
    assert(@m.younger_semantic_siblings.s_exp?)
  end
end

class TestMatchConstructedFromFlatArray < Test::Unit::TestCase
  def setup
    @s1 = MethodTrails::SExp.new([:a, :b, :c, :d, :e])
    @m1 = MethodTrails::Match.new(@s1, 2, @s1, 2)
  end
  def test_head_index_reader
    assert_equal(2, @m1.head_index)
  end
  def test_tail_index_reader
    assert_equal(2, @m1.tail_index)
  end
  def test_head
    assert_equal(:c.to_atom, @m1.head)
    assert(@m1.head.atom?)
  end
  def test_head_and_semantic_children
    assert_equal([:c].to_s_exp, @m1.head_and_semantic_children)
    assert(@m1.head_and_semantic_children.s_exp?)
  end
  def test_tail
    assert_equal(:c.to_atom, @m1.tail)
  end
  def test_older_adjacent_sibling
    assert_equal(:b.to_atom, @m1.older_adjacent_sibling)
  end
  def test_older_siblings
    assert_equal([:a, :b].to_s_exp, @m1.older_siblings)
  end
  def test_head_sibl_reader
    assert_equal([:a, :b, :c, :d, :e].to_s_exp, @m1.head_sibl)
  end
  def test_tail_sibl_reader
    assert_equal([:a, :b, :c, :d, :e].to_s_exp, @m1.tail_sibl)
  end
  def test_semantic_children
    assert_equal([].to_s_exp, @m1.semantic_children)
  end
  def test_semantic_descendants
    assert_equal([].to_s_exp, @m1.semantic_children)
  end
  def test_siblings
    assert_equal([:a, :b, :d, :e].to_s_exp, @m1.siblings)
  end
  def test_siblings_including_me
    assert_equal([:a, :b, :c, :d, :e].to_s_exp, @m1.siblings(true))
  end
  def test_younger_adjacent_sibling
    assert_equal(:d.to_atom, @m1.younger_adjacent_sibling)
  end
  def test_younger_semantic_siblings
    assert_equal([:d, :e].to_s_exp, @m1.younger_semantic_siblings)
    assert(@m1.younger_semantic_siblings.s_exp?)
  end
  def test_younger_siblings
    assert_equal([:d, :e].to_s_exp, @m1.younger_siblings)
  end
end

class TestMatchConstructedFromNestedArray < Test::Unit::TestCase
  def setup
    @s1 = MethodTrails::SExp.new([0, 1, [2, 3], 4, [5, 6], [7, 8], 9, 10, [11, 12]])
    @m1 = MethodTrails::Match.new(@s1, 3, @s1, 3)
  end
  def test_head_index_reader
    assert_equal(3, @m1.head_index)
  end
  def test_tail_index_reader
    assert_equal(3, @m1.tail_index)
  end
  def test_head
    assert_equal(4.to_atom, @m1.head)
  end
  def test_head_and_semantic_children
    assert_equal([4, [5, 6], [7, 8]].to_s_exp, @m1.head_and_semantic_children)
  end
  def test_tail
    assert_equal(4.to_atom, @m1.tail)
  end
  def test_older_adjacent_sibling
    assert_equal([2, 3].to_s_exp, @m1.older_adjacent_sibling)
  end
  def test_older_siblings
    assert_equal([0, 1, [2, 3]].to_s_exp, @m1.older_siblings)
  end
  def test_head_sibl_reader
    assert_equal([0, 1, [2, 3], 4, [5, 6], [7, 8], 9, 10, [11, 12]].to_s_exp, @m1.head_sibl)
  end
  def test_tail_sibl_reader
    assert_equal([0, 1, [2, 3], 4, [5, 6], [7, 8], 9, 10, [11, 12]].to_s_exp, @m1.tail_sibl)
  end
  def test_semantic_children
    assert_equal([[5, 6].to_s_exp, [7, 8].to_s_exp], @m1.semantic_children)
  end
  def test_semantic_descendants
    assert_equal([[5, 6].to_s_exp, [7, 8].to_s_exp], @m1.semantic_children)
  end
  def test_siblings
    assert_equal([0, 1, [2, 3], [5, 6], [7, 8], 9, 10, [11, 12]].to_s_exp, @m1.siblings)
  end
  def test_siblings_including_me
    assert_equal([0, 1, [2, 3], 4, [5, 6], [7, 8], 9, 10, [11, 12]].to_s_exp, @m1.siblings(true))
  end
  def test_younger_adjacent_sibling
    assert_equal([5, 6].to_s_exp, @m1.younger_adjacent_sibling)
  end
  def test_younger_semantic_siblings
    assert_equal([9, 10, [11, 12]].to_s_exp, @m1.younger_semantic_siblings)
    assert(@m1.younger_semantic_siblings.s_exp?)
  end
  def test_younger_siblings
    assert_equal([[5, 6], [7, 8], 9, 10, [11, 12]].to_s_exp, @m1.younger_siblings)
  end
end

class TestMatchEquality < Test::Unit::TestCase
  def setup
    @s1 = MethodTrails::SExp.new([:a, :b, :c])
    @m1 = MethodTrails::Match.new(@s1, 1, @s1, 1)
    @s2 = MethodTrails::SExp.new([:a, :b, :c])
    @m2 = MethodTrails::Match.new(@s2, 1, @s2, 1)
  end
  include MatchObjectsShouldBeEqualButDistinct
end

class TestMatchDuplication < Test::Unit::TestCase
  def setup
    @s1 = MethodTrails::SExp.new([:a, :b, :c])
    @m1 = MethodTrails::Match.new(@s1, 1, @s1, 1)
    @m2 = @m1.dup
  end
  include MatchInternalObjectsShouldBeDistinct
  include MatchObjectsShouldBeEqualButDistinct
end

class TestMatchCloning < Test::Unit::TestCase
  def setup
    @s1 = MethodTrails::SExp.new([:a, :b, :c])
    @m1 = MethodTrails::Match.new(@s1, 1, @s1, 1)
    @m2 = @m1.clone
  end
  include MatchInternalObjectsShouldBeDistinct
  include MatchObjectsShouldBeEqualButDistinct
end

class TestSemantics_0_1_2 < Test::Unit::TestCase
  def setup
    @s = MethodTrails::SExp.new([0, [1, 2], 3, 4, [5, 6]])
    @m = MethodTrails::Match.new(@s, 0, @s, 0)
  end
  def test_head_and_semantic_children
    assert_equal([0, [1, 2]].to_s_exp, @m.head_and_semantic_children)
  end
  def test_semantic_children
    sc = []
    sc << [1, 2].to_s_exp
    assert_equal(sc, @m.semantic_children)
  end
  def test_semantic_descendants
    sd = []
    sd << [1, 2].to_s_exp
    assert_equal(sd, @m.semantic_descendants)
  end
  include SemanticSiblingsShouldBeCorrectFor_0_1_2_Examples
end

class TestSemantics_0_1_2n < Test::Unit::TestCase
  def setup
    @s = MethodTrails::SExp.new([0, [1, [2]], 3, 4, [5, 6]])
    @m = MethodTrails::Match.new(@s, 0, @s, 0)
  end
  def test_head_and_semantic_children
    assert_equal([0, [1, [2]]].to_s_exp, @m.head_and_semantic_children)
  end
  def test_semantic_children
    sc = []
    sc << [1, [2]].to_s_exp
    assert_equal(sc, @m.semantic_children)
  end
  def test_semantic_descendants
    sd = []
    sd << [1, [2]].to_s_exp
    sd << [2].to_s_exp
    assert_equal(sd, @m.semantic_descendants)
  end
  include SemanticSiblingsShouldBeCorrectFor_0_1_2_Examples
end

class TestSemantics_0_1n_2 < Test::Unit::TestCase
  def setup
    @s = MethodTrails::SExp.new([0, [[1], 2], 3, 4, [5, 6]])
    @m = MethodTrails::Match.new(@s, 0, @s, 0)
  end
  def test_head_and_semantic_children
    assert_equal([0, [[1], 2]].to_s_exp, @m.head_and_semantic_children)
  end
  def test_semantic_children
    sc = []
    sc << [[1], 2].to_s_exp
    assert_equal(sc, @m.semantic_children)
  end
  def test_semantic_descendants
    sd = []
    sd << [[1], 2].to_s_exp
    sd << [1].to_s_exp
    assert_equal(sd, @m.semantic_descendants)
  end
  include SemanticSiblingsShouldBeCorrectFor_0_1_2_Examples
end

class TestSemantics_0_1n_2n < Test::Unit::TestCase
  def setup
    @s = MethodTrails::SExp.new([0, [[1], [2]], 3, 4, [5, 6]])
    @m = MethodTrails::Match.new(@s, 0, @s, 0)
  end
  def test_head_and_semantic_children
    assert_equal([0, [[1], [2]]].to_s_exp, @m.head_and_semantic_children)
  end
  def test_semantic_children
    sc = []
    sc << [[1], [2]].to_s_exp
    assert_equal(sc, @m.semantic_children)
  end
  def test_semantic_descendants
    sd = []
    sd << [[1], [2]].to_s_exp
    sd << [1].to_s_exp
    sd << [2].to_s_exp
    assert_equal(sd, @m.semantic_descendants)
  end
  include SemanticSiblingsShouldBeCorrectFor_0_1_2_Examples
end

class TestSemantics_0_1n_2n_3n_4n < Test::Unit::TestCase
  def setup
    @s = MethodTrails::SExp.new([0, [[1], [2]], [[3], [4]], 5, 6])
    @m = MethodTrails::Match.new(@s, 0, @s, 0)
  end
  def test_head_and_semantic_children
    hsc = []
    hsc << 0.to_atom
    hsc << [[1], [2]].to_s_exp
    hsc << [[3], [4]].to_s_exp
    assert_equal(hsc, @m.head_and_semantic_children)
  end
  def test_semantic_children
    sc = []
    sc << [[1], [2]].to_s_exp
    sc << [[3], [4]].to_s_exp
    assert_equal(sc, @m.semantic_children)
  end
  def test_semantic_descendants
    sd = []
    sd << [[1], [2]].to_s_exp
    sd << [1].to_s_exp
    sd << [2].to_s_exp
    sd << [[3], [4]].to_s_exp
    sd << [3].to_s_exp
    sd << [4].to_s_exp
    assert_equal(sd, @m.semantic_descendants)
  end
  def test_younger_semantic_siblings
    assert_equal([5, 6].to_s_exp, @m.younger_semantic_siblings)
    assert(@m.younger_semantic_siblings.s_exp?)
  end
end

class TestSemanticsForDeeplyNestedSExp < Test::Unit::TestCase
  def setup
    @s = MethodTrails::SExp.new([0, 1, [2, [3, 4], [5, 6, [7, 8]], 9], [10, 11], 12])
    @m = MethodTrails::Match.new(@s, 1, @s, 1)
  end
  def test_head_and_semantic_children
    hsc = []
    hsc << 1.to_atom
    hsc << [2, [3, 4], [5, 6, [7, 8]], 9].to_s_exp
    hsc << [10, 11].to_s_exp
    assert_equal(hsc, @m.head_and_semantic_children)
  end
  def test_semantic_children
    sc = []
    sc << [2, [3, 4], [5, 6, [7, 8]], 9].to_s_exp
    sc << [10, 11].to_s_exp
    assert_equal(sc, @m.semantic_children)
  end
  def test_semantic_descendants
    sd = []
    sd << [2, [3, 4], [5, 6, [7, 8]], 9].to_s_exp
    sd << [3, 4].to_s_exp
    sd << [5, 6, [7, 8]].to_s_exp
    sd << [7, 8].to_s_exp
    sd << [10, 11].to_s_exp
    assert_equal(sd, @m.semantic_descendants)
  end
end
