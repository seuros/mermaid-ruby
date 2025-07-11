# frozen_string_literal: true

require 'test_helper'

class AllDiagramsTest < UnitTest
  def test_all_diagram_classes_have_to_mermaid_method
    diagram_classes = [
      Diagrams::StateDiagram,
      Diagrams::ClassDiagram,
      Diagrams::FlowchartDiagram,
      Diagrams::PieDiagram,
      Diagrams::GanttDiagram,
      Diagrams::GitgraphDiagram,
      Diagrams::TimelineDiagram,
      Diagrams::ERDiagram
    ]

    diagram_classes.each do |diagram_class|
      # Create a new instance of the diagram
      diagram = diagram_class.new

      # Assert that the instance responds to to_mermaid
      assert_respond_to diagram, :to_mermaid,
                        "#{diagram_class} should have a to_mermaid method"

      # Assert that calling to_mermaid returns a string
      result = diagram.to_mermaid

      assert_kind_of String, result,
                     "#{diagram_class}#to_mermaid should return a String"

      # Assert that the string is not empty (basic sanity check)
      refute_empty result.strip,
                   "#{diagram_class}#to_mermaid should return a non-empty string"
    end
  end

  def test_all_diagram_instances_produce_valid_mermaid_syntax_structure
    diagram_classes_with_expected_prefixes = {
      Diagrams::StateDiagram => 'stateDiagram-v2',
      Diagrams::ClassDiagram => 'classDiagram',
      Diagrams::FlowchartDiagram => 'graph',
      Diagrams::PieDiagram => 'pie',
      Diagrams::GanttDiagram => 'gantt',
      Diagrams::GitgraphDiagram => 'gitGraph',
      Diagrams::TimelineDiagram => 'timeline',
      Diagrams::ERDiagram => 'erDiagram'
    }

    diagram_classes_with_expected_prefixes.each do |diagram_class, expected_prefix|
      diagram = diagram_class.new
      result = diagram.to_mermaid

      assert result.start_with?(expected_prefix),
             "#{diagram_class}#to_mermaid should start with '#{expected_prefix}', got: #{result.lines.first&.strip}"
    end
  end
end
