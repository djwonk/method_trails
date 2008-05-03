require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'
require_relative '/../../helpers/child_cstra_rstrb_rstrc_rstrd'

class TestChildWithRightChildWithLeftChild_CapStrA_RegStrB_RegStrC_RegStrD < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
    [ :__child,
      [ "%a",
        [ :__child,
          [ 
            [ :__child,
              [ "b",
                "c"
              ]
            ],
            "d",
          ]
        ]
      ]
    ]
    )
  end
  include ShouldBehaveLikeChild_CapStrA_RegStrB_RegStrC_RegStrD
end
