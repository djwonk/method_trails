require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'
require_relative '/../../helpers/child_rstra_cstrb_rstrc'

class TestChildWithLeftChild_RegStrA_CapStrB_RegStrC < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
    [ :__child,
      [
        [ :__child,
          [ "a",
            "%b"
          ]
        ],
        "c",
      ]
    ]
    )
  end
  include ShouldBehaveLikeChild_RegStrA_CapStrB_RegStrC
end
