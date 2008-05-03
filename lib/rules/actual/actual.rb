require 'require_relative'
require_relative '/../factory'

class RubyGraph
  class Rules
    module Actual
      
      def self.rules
        rs = []
        [
          # find_class_names,
          # find_instance_methods,
          # find_class_methods,
          find_classes_and_their_instance_methods,
          find_identifiers_in_instance_methods,
        ].each { |r| rs << r }
        rs
      end

      protected
      
      extend Factory
      
      # Find the names of all classes
      def self.find_class_names
        rule_factory(:classes,
          %{:class > (:const_ref > (:@const + %class))},
          [ :__child,
            [ :class,
              [ :__child,
                [ :const_ref,
                  [ :__adjacent_sibling,
                    [ :@const,
                      "%class"
                    ]
                  ]
                ]
              ]
            ]
          ])
      end

      # %{:class > (:const_ref > (:@const + %class))},
      # %{:class + (nil > (:body_stmt (:def > (:@ident + %def))))},
      def self.find_classes_and_their_instance_methods
        rule_factory(:classes_and_i_methods,
          %{},
          [ [:__child, :__adjacent_sibling],
            [ :class, 
              [ :__child, # :__child
                [ :const_ref,
                  [ :__adjacent_sibling,
                    [ :@const,
                      "%class"
                    ]
                  ]
                ]
              ],
              [ :__child, # :__adjacent_sibling
                [ nil,
                  [ :__descendant,
                    [ :body_stmt,
                      [ :__child,
                        [ :def,
                          [ :__adjacent_sibling,
                            [ :@ident,
                              "%def"
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ])
      end
      
      # Find the names of all instance methods in a class
      def self.find_instance_methods
        rule_factory(:i_methods,
          %{:class + (nil > (:body_stmt (:def > (:@ident + %def))))},
          [ :__general_sibling,
            [ :class,
              [ :__child,
                [ nil,
                  [ :__descendant,
                    [ :body_stmt,
                      [ :__child,
                        [ :def,
                          [ :__adjacent_sibling,
                            [ :@ident,
                              "%def"
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ])
      end
      
      # Find the names of all class methods in a class
      # %{:class > (:body_stmt > (:defs > (:@ident + %def)))}
      def self.find_class_methods
        rule_factory(:c_methods,
        %{:class + (nil > (:body_stmt (:defs > (:@ident + %defs))))},
        [ :__general_sibling,
          [ :class,
            [ :__child,
              [
                nil,
                [ :__descendant,
                  [ :body_stmt,
                    [ :__child,
                      [ :defs,
                        [ :__adjacent_sibling,
                          [ :@ident,
                            "%defs"
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]
        ])
      end
      
      # Finds some identifiers in an instance method
      # (But it does not find 'jump' out of 'm.jump')
      def self.rule_4a
        rule_factory("4a",
          %{:def > (:body_stmt (:var_ref > (:@ident + %ident)))},
          [ :__child,
            [ :def,
              [ :__descendant,
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
          ])
      end

      def self.rule_4b
        rule_factory("4b",
          %{:def > (:@ident + %def)},
          [ :__child,
            [ :def,
              [ :__adjacent_sibling,
                [ :@ident,
                  "%def"
                ]
              ]
            ]
          ])
      end

      # Finds all identifiers in an instance method
      def self.find_identifiers_in_instance_methods
        rule_factory(:i_methods_and_ids,
          %{},
          [ :__child,
            [ :def,
              [ :__descendant,
                [ :body_stmt,
                  [ :__adjacent_sibling,
                    [ :@ident,
                      "%ident"
                    ]
                  ]
                ]
              ],
              [ :__adjacent_sibling,
                [ :@ident,
                  "%def"
                ]
              ]
            ]
          ])
      end

      # Finds some identifiers in an instance method
      # (But it does not find 'jump' out of 'm.jump')
      # :def > (:body_stmt (:var_ref > (:@ident + %ident)))
      # :def > (:@ident + %def)
      #
      # I now prefer using find_identifiers_in_instance_methods instead
      def self.rule_find_some_identifiers_in_instance_methods
        rule_factory :i_methods_and_ids,
          %{},
          [ :__child,
            [ :def,
              [ :__descendant,
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
              ],
              [ :__adjacent_sibling,
                [ :@ident,
                  "%def"
                ]
              ]
            ]
          ]
      end

    end
  end
end
