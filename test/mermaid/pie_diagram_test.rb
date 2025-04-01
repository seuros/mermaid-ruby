# frozen_string_literal: true

require 'test_helper'

class PieDiagramStringTest < UnitTest
  def test_empty_pie
    diagram = Diagrams::PieDiagram.new(title: 'Empty', slices: [])
    expected = <<~MERMAID
      pie
      title Empty
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_simple_pie
    slices = [
      Diagrams::Elements::Slice.new(label: 'A', value: 30),
      Diagrams::Elements::Slice.new(label: 'B', value: 70)
    ]
    diagram = Diagrams::PieDiagram.new(title: 'Simple Pie', slices: slices)
    expected = <<~MERMAID
      pie
      title Simple Pie
      "A" : 30
      "B" : 70
    MERMAID
    # Normalize whitespace/newlines for comparison
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_pie_without_title
    slices = [
      Diagrams::Elements::Slice.new(label: 'Work', value: 8),
      Diagrams::Elements::Slice.new(label: 'Sleep', value: 8),
      Diagrams::Elements::Slice.new(label: 'Play', value: 8)
    ]
    diagram = Diagrams::PieDiagram.new(slices: slices) # No title
    expected = <<~MERMAID
      pie
      "Work" : 8
      "Sleep" : 8
      "Play" : 8
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_pie_with_float_values
    slices = [
      Diagrams::Elements::Slice.new(label: 'X', value: 15.5),
      Diagrams::Elements::Slice.new(label: 'Y', value: 84.5)
    ]
    diagram = Diagrams::PieDiagram.new(title: 'Floats', slices: slices)
    expected = <<~MERMAID
      pie
      title Floats
      "X" : 15.5
      "Y" : 84.5
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end
end

# class PieDiagramIntegrationTest < IntegrationTest
#   # Tests that run in a headless browser
#   # Temporarily commented out due to flakiness (Ferrum::PendingConnectionsError)
#
#   def test_simple_pie_renders
#     slices = [
#       Diagrams::Elements::Slice.new(label: 'Yes', value: 80),
#       Diagrams::Elements::Slice.new(label: 'No', value: 20)
#     ]
#     diagram = Diagrams::PieDiagram.new(title: 'Survey Results', slices: slices)
#     mermaid_string = diagram.to_mermaid
#     assert render_mermaid_and_check_errors(mermaid_string), "Simple pie should render without errors"
#   end
#
#   def test_pie_no_title_renders
#      slices = [
#       Diagrams::Elements::Slice.new(label: 'Alpha', value: 1),
#       Diagrams::Elements::Slice.new(label: 'Beta', value: 2),
#       Diagrams::Elements::Slice.new(label: 'Gamma', value: 3)
#     ]
#     diagram = Diagrams::PieDiagram.new(slices: slices)
#     mermaid_string = diagram.to_mermaid
#     assert render_mermaid_and_check_errors(mermaid_string), "Pie without title should render without errors"
#   end
# end
# end
# end
