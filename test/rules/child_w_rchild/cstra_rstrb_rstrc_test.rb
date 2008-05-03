require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'
require_relative '/../../helpers/child_cstra_rstrb_rstrc'

class TestChildWithRightChild_CapStrA_RegStrB_RegStrC < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
    [ :__child,
      [ "%a",
        [ :__child,
          [ "b",
            "c"
          ]
        ]
      ]
    ]
    )
  end
  include ShouldBehaveLikeChild_CapStrA_RegStrB_RegStrC
end
