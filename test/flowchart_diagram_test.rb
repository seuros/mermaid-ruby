# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class FlowchartDiagramTest < DiagramTest

    EXPECTED_RESULT = <<~RESULT
flowchart LR
  A[Hard] -->|Text| B(Round)
  B --> C{Decision}
  C -->|One| D[Result 1]
  C -->|Two| E[Result 2]
    RESULT

    def test_generate
      diagram = FlowchartDiagram.new(
        id: 'flowchart_1',
        direction: 'LR',
        nodes: [
          { id: 'A', label: 'Hard' },
          { id: 'B', label: 'Round', shape: 'round' },
          { id: 'C', label: 'Decision', shape: 'rhombus' },
          { id: 'D', label: 'Result 1' },
          { id: 'E', label: 'Result 2' },
        ],
        links: [
          { from: 'A', to: 'B', label: 'Text' },
          { from: 'B', to: 'C' },
          { from: 'C', to: 'D', label: 'One' },
          { from: 'C', to: 'E', label: 'Two' }
        ]
      )

      assert_equal EXPECTED_RESULT, diagram.to_s
    end


    # def test_parser
    #
    #   diagram = FlowchartDiagram.parse(EXPECTED_RESULT)
    #
    #   # assert_equal 'flowchart_1', diagram.id
    #   assert_equal 'LR', diagram.direction
    #   assert_equal 3, diagram.nodes.size
    #   assert_equal 2, diagram.edges.size
    # end
  end
end
