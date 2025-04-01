# frozen_string_literal: true

require 'test_helper'

class GanttDiagramStringTest < UnitTest
  def test_empty_gantt
    diagram = Diagrams::GanttDiagram.new(title: 'Empty', tasks: [])
    expected = <<~MERMAID
      gantt
      title Empty
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_simple_gantt
    tasks = [
      Diagrams::Elements::Task.new(id: 'task1', name: 'Task One', start_date: '2024-01-01', end_date: '2024-01-05'),
      Diagrams::Elements::Task.new(id: 'task2', name: 'Task Two', start_date: '2024-01-06', end_date: '2024-01-08')
    ]
    diagram = Diagrams::GanttDiagram.new(title: 'Project Plan', tasks: tasks)
    expected = <<~MERMAID
      gantt
      title Project Plan
      Task One :task1, 2024-01-01, 2024-01-05
      Task Two :task2, 2024-01-06, 2024-01-08
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_gantt_without_title
    tasks = [
      Diagrams::Elements::Task.new(id: 'a', name: 'Task A', start_date: '2023-12-01', end_date: '2023-12-03')
    ]
    diagram = Diagrams::GanttDiagram.new(tasks: tasks) # No title
    expected = <<~MERMAID
      gantt
      Task A :a, 2023-12-01, 2023-12-03
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  # Mermaid Gantt also supports sections, durations, etc.
  # The current diagram gem Task class only has start/end dates.
  # Add more tests if Task class is extended later.
end
