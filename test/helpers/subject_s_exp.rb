require 'require_relative'
require_relative '/../../lib/classes/s_exp'

SUBJECT_S_EXP = 
[:program,
 [
  [:class,
   [:const_ref, [:@const, "VerySimple", [1, 6]]],
   nil,
   [:body_stmt,
    [
     [:def,
      [:@ident, "method_one", [2, 6]],
      [:params, nil, nil, nil, nil, nil],
      [:body_stmt,
       [
        [:var_ref, [:@ident, "method_two", [3, 4]]]
       ],
       nil,
       nil,
       nil
      ]
     ],
     [:def,
      [:@ident, "method_two", [5, 6]],
      [:params, nil, nil, nil, nil, nil],
      [:body_stmt,
       [
        [:binary,
         [
          :binary, [:@int, "1", [6, 4]],
          :+,
          [:@int, "2", [6, 8]]
         ],
         :+,
         [:@int, "3", [6, 12]]
        ]
       ],
       nil,
       nil,
       nil
      ]
     ]
    ],
    nil,
    nil,
    nil
   ]
  ]
 ]
].to_s_exp
