require 'require_relative'
require_relative '/../factory'

class MethodTrails
  class Rules
    module Practice

      def self.rules
        rs = []
        [
          rule_p1,
          rule_p4,
        ].each { |r| rs << r }
        rs
      end

      protected

      extend Factory

      def self.rule_p1
        rule_factory "P1",
          %{:const_ref > (:@const + %s)},
          [ :__child,
            [ :const_ref,
              [ :__adjacent_sibling,
                [ :@const,
                  "%s"
                ]
              ]
            ]
          ]
      end

      # Intended to find all identifiers in an instance method
      # (Using >, however, is too strict.)
      def self.rule_p4
        rule_factory "P4",
          %{:def > (:body_stmt > (:var_ref > (:@ident + %ident)))},
          [ :__child,
            [ :def,
              [ :__child,
                [ :body_stmt,
                  [ :__child,
                    [ :var_ref,
                      [ :__adjacent_sibling,
                        [ :@ident,
                          "%ident"
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
      end

    end
  end
end
