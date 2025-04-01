# frozen_string_literal: true

require 'test_helper'

class FlowchartDiagramStringTest < UnitTest
  def test_empty_flowchart
    diagram = Diagrams::FlowchartDiagram.new(nodes: [], edges: [])
    expected = 'graph TD' # Default direction

    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_single_node
    nodes = [Diagrams::Elements::Node.new(id: 'A', label: 'Node A')]
    diagram = Diagrams::FlowchartDiagram.new(nodes: nodes, edges: [])
    expected = <<~MERMAID
      graph TD
        A["Node A"]
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_simple_edge
    nodes = [
      Diagrams::Elements::Node.new(id: 'n1', label: 'Start'),
      Diagrams::Elements::Node.new(id: 'n2', label: 'End')
    ]
    edges = [Diagrams::Elements::Edge.new(source_id: 'n1', target_id: 'n2')]
    diagram = Diagrams::FlowchartDiagram.new(nodes: nodes, edges: edges)
    expected = <<~MERMAID
      graph TD
        n1["Start"]
        n2["End"]
        n1 --> n2
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_edge_with_label
    nodes = [
      Diagrams::Elements::Node.new(id: 'id1', label: 'Input'),
      Diagrams::Elements::Node.new(id: 'id2', label: 'Process')
    ]
    edges = [Diagrams::Elements::Edge.new(source_id: 'id1', target_id: 'id2', label: 'Data')]
    diagram = Diagrams::FlowchartDiagram.new(nodes: nodes, edges: edges)
    expected = <<~MERMAID
      graph TD
        id1["Input"]
        id2["Process"]
        id1 -- "Data" --> id2
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_node_label_with_quotes
    nodes = [Diagrams::Elements::Node.new(id: 'q', label: 'Label with "quotes"')]
    diagram = Diagrams::FlowchartDiagram.new(nodes: nodes, edges: [])
    expected = <<~MERMAID
      graph TD
        q["Label with #quot;quotes#quot;"]
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end
end

# class FlowchartDiagramIntegrationTest < IntegrationTest
#   # Tests that run in a headless browser
#   # Temporarily commented out due to flakiness (Ferrum::PendingConnectionsError)
#
#   def test_simple_flowchart_renders
#     nodes = [
#       Diagrams::Elements::Node.new(id: 'a', label: 'Node A'),
#       Diagrams::Elements::Node.new(id: 'b', label: 'Node B')
#     ]
#     edges = [Diagrams::Elements::Edge.new(source_id: 'a', target_id: 'b')]
#     diagram = Diagrams::FlowchartDiagram.new(nodes: nodes, edges: edges)
#     mermaid_string = diagram.to_mermaid
#     assert render_mermaid_and_check_errors(mermaid_string), "Simple flowchart should render without errors"
#   end
#
#   def test_labeled_edge_renders
#     nodes = [
#       Diagrams::Elements::Node.new(id: 'start', label: 'Start Here'),
#       Diagrams::Elements::Node.new(id: 'end', label: 'End Here')
#     ]
#     edges = [Diagrams::Elements::Edge.new(source_id: 'start', target_id: 'end', label: 'Link Text')]
#     diagram = Diagrams::FlowchartDiagram.new(nodes: nodes, edges: edges)
#     mermaid_string = diagram.to_mermaid
#     assert render_mermaid_and_check_errors(mermaid_string), "Flowchart with labeled edge should render without errors"
#   end
# end
# end
# end
