# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class ClassDiagramTest < DiagramTest
    EXPECTED_DIAGRAM = <<~DIAGRAM
      classDiagram
        class BankAccount["User BankAccount"] {
          +String owner
          +BigDecimal balance
          +deposit(amount) bool
          +withdrawal(amount) int
          }
    DIAGRAM
    def test_diagram
      diagram = ClassDiagram.new(
        classes: [
          {
            id: 'BankAccount',
            label: 'User BankAccount',
            fields: [
              { name: 'owner', type: 'String' },
              { name: 'balance', type: 'BigDecimal' }
            ],
            functions: [
              { name: 'deposit', return_type: 'bool', arguments: [{ name: 'amount' }] },
              { name: 'withdrawal', return_type: 'int', arguments: [{ name: 'amount' }] }
            ]
          }
        ]
      )

      assert_equal EXPECTED_DIAGRAM, diagram.to_s
    end
  end
end
