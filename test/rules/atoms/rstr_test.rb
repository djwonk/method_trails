require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'

class TestAtoms_RegStr < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(["a", "b"])
  end
  def test_rule_is_malformed_so_should_raise_exception
    @subject = ["a", "b"].to_s_exp
    assert_raise(RubyGraph::RuleException) do
      @rule.matches(@subject)
    end
  end
  def teardown
    assert_equal(nil, @rule.captured)
  end
end
