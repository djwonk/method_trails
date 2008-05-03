require 'test/unit'
require 'require_relative'
require_relative '/../../lib/classes/atom'
require_relative '/../../lib/classes/s_exp'
require_relative '/../../lib/traverser/traverser'

module TraverserHelper
  def run_traverser
    t = RubyGraph::Traverser.new(@entire_s_exp)
    @atoms = []
    @s_exps = []
    t.atom_callback  = lambda do |atom, pos|
      @atoms << atom
    end
    t.s_exp_callback = lambda do |s_exp, pos|
      @s_exps << s_exp
    end
    t.run
  end
end

class TestTraverserSimple < Test::Unit::TestCase
  include TraverserHelper
  def setup
    @entire_array = [:a, [:b, :c]]
    @entire_s_exp = @entire_array.to_s_exp
    run_traverser
  end
  def test_entire_s_exp
    assert(@entire_s_exp.s_exp?)
    assert(@entire_s_exp[0].atom?)
    assert(@entire_s_exp[1].s_exp?)
    assert(@entire_s_exp[1][0].atom?)
    assert(@entire_s_exp[1][1].atom?)
  end
  def test_that_atoms_are_populated
    expected = @entire_array.flatten.collect { |x| x.to_atom }
    assert_equal(expected, @atoms)
  end
  def test_that_s_exps_are_populated
    e = []
    e << [:a, [:b, :c]].to_s_exp
    e << [:b, :c].to_s_exp
    assert_equal(e, @s_exps)
  end
end

class TestTraverserMedium < Test::Unit::TestCase
  include TraverserHelper
  def setup
    @entire_array = [[[:a, [:b, :c]], :d], :e]
    @entire_s_exp = @entire_array.to_s_exp
    run_traverser
  end
  def test_entire_s_exp
    assert(@entire_s_exp.s_exp?)
    assert(@entire_s_exp[0].s_exp?)
    assert(@entire_s_exp[1].atom?)
    assert(@entire_s_exp[0][0].s_exp?)
    assert(@entire_s_exp[0][1].atom?)
    assert(@entire_s_exp[0][0][0].atom?)
    assert(@entire_s_exp[0][0][1].s_exp?)
    assert(@entire_s_exp[0][0][1][0].atom?)
    assert(@entire_s_exp[0][0][1][1].atom?)
  end
  def test_that_atoms_are_populated
    expected = @entire_array.flatten.collect { |x| x.to_atom }
    assert_equal(expected, @atoms)
  end
  def test_that_s_exps_are_populated
    expected = []
    expected << [[[:a, [:b, :c]], :d], :e].to_s_exp
    expected << [[:a, [:b, :c]], :d].to_s_exp
    expected << [:a, [:b, :c]].to_s_exp
    expected << [:b, :c].to_s_exp
    assert_equal(expected, @s_exps)
  end
end
