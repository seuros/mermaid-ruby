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
