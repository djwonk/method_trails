require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'
require_relative '/../../helpers/child_rstra_rstrb_rstrc_rstrd'

class TestChildWithLeftChildWithRightChild_RegStrA_RegStrB_RegStrC_RegStrD < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
    [ :__child,
      [
        [ :__child,
          [ "a",
            [ :__child,
              [ "b",
                "c"
              ]
            ]
          ]
        ],
        "d"
      ]
    ]
    )
  end
  include ShouldBehaveLikeChild_RegStrA_RegStrB_RegStrC_RegStrD
end
