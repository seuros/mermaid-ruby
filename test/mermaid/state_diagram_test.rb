# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class StateDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~RESULT
      stateDiagram-v2
        [*] --> Still
        Still --> [*]
        Still --> Moving
        Moving --> Still
        Moving --> Crash
        Crash --> [*]
    RESULT

    def test_diagram
      diagram = StateDiagram.new(
        id: 'state_diagram_1',
        states: [
          { id: 'Still' },
          { id: 'Moving' },
          { id: 'Crash' }
        ],
        transitions: [
          { from: 'start', to: 'Still' },
          { from: 'Still', to: 'end' },
          { from: 'Still', to: 'Moving' },
          { from: 'Moving', to: 'Still' },
          { from: 'Moving', to: 'Crash' },
          { from: 'Crash', to: 'end' }
        ]
      )

      assert_equal EXPECTED_RESULT, diagram.to_s
    end
  end
end
