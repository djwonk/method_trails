require 'test/unit'
require 'require_relative'
require_relative '/../../helpers/rule_helper'
require_relative '/../../helpers/child_rstra_cstrb_rstrc_rstrd'

class TestChildWithLeftChildWithLeftChild_RegStrA_CapStrB_RegStrC_RegStrD < Test::Unit::TestCase
  include RuleHelper
  def setup
    @rule = new_rule(
    [ :__child,
      [
        [ :__child,
          [
            [ :__child,
              [ "a",
                "%b"
              ]
            ],
            "c"
          ]
        ],
        "d"
      ]
    ]
    )
  end
  include ShouldBehaveLikeChild_RegStrA_CapStrB_RegStrC_RegStrD
end
