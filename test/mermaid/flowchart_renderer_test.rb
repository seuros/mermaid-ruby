# frozen_string_literal: true

require 'test_helper'

class FlowchartRendererTest < Minitest::Test
  def test_nodes_and_edges
    diagram = Diagrams::FlowchartDiagram.new
    diagram.add_node(id: 'a', label: 'Say "hi"')
    diagram.add_node(id: 'b', label: 'Done')
    diagram.add_edge(source_id: 'a', target_id: 'b', label: 'next')
    diagram.add_edge(source_id: 'b', target_id: 'a')

    assert_mermaid <<~MERMAID, diagram
      flowchart TD
        a["Say #34;hi#34;"]
        b["Done"]
        a -->|"next"| b
        b --> a
    MERMAID
  end
end
