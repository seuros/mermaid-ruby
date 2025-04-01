# frozen_string_literal: true

require 'test_helper'

class GanttDiagramStringTest < UnitTest
  def test_empty_gantt
    diagram = Diagrams::GanttDiagram.new(title: 'Empty')
    # No tasks to add here
    # Expect default section even if empty
    expected = <<~MERMAID
      gantt
      title Empty
      section Default Section
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_simple_gantt
    diagram = Diagrams::GanttDiagram.new(title: 'Project Plan')
    diagram.add_task(id: 'task1', label: 'Task One', start: '2024-01-01', duration: '5d')
    diagram.add_task(id: 'task2', label: 'Task Two', start: '2024-01-06', duration: '3d')
    # Expect tasks within the default section
    expected = <<~MERMAID
      gantt
      title Project Plan
      section Default Section
      Task One :task1, 2024-01-01, 5d
      Task Two :task2, 2024-01-06, 3d
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_gantt_without_title
    diagram = Diagrams::GanttDiagram.new # No title
    diagram.add_task(id: 'a', label: 'Task A', start: '2023-12-01', duration: '3d')
    # Expect task within the default section
    expected = <<~MERMAID
      gantt
      section Default Section
      Task A :a, 2023-12-01, 3d
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  # Mermaid Gantt also supports sections, durations, etc.
  # The current diagram gem Task class only has start/end dates.
  # Add more tests if Task class is extended later.
end
