require 'require_relative'
require_relative '/../../lib/classes/s_exp'
require_relative '/../../lib/rule/rule'

module RuleHelper
  
  def new_rule(rule_array)
    rule = RubyGraph::Rule.new
    rule.s_exp = rule_array.to_s_exp
    rule
  end
  def assert_match_head_index_equals(list)
    values = list.each # external iterator
    wrapper_for_each_match do |match|
      assert_equal(values.next, match.head_index)
    end
  end
  def assert_match_tail_index_equals(list)
    values = list.each # external iterator
    wrapper_for_each_match do |match|
      assert_equal(values.next, match.tail_index)
    end
  end
  
  protected
  
  # It is somewhat dubious that I am testing 'each_match' directly!
  def wrapper_for_each_match
    initial = RubyGraph::Match.new(@subject, nil, @subject, nil)
    @rule.each_match(@rule.s_exp, @subject, initial) do |match|
      # finalize_captures(match.captured)
      yield(match)
    end
  end
  
end
