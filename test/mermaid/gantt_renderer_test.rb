# frozen_string_literal: true

require 'test_helper'

class GanttRendererTest < Minitest::Test
  def test_sections_and_tasks
    diagram = Diagrams::GanttDiagram.new(title: 'Launch')
    diagram.add_task(id: 'kick', label: 'Kickoff', start: '2026-01-05', duration: '1d', status: :milestone)
    diagram.add_section(title: 'Build')
    diagram.add_task(id: 'code', label: 'Code', start: 'after kick', duration: '2w', status: :crit)
    diagram.add_task(id: 'ship', label: 'Ship', start: 'after code', duration: '1d')

    assert_mermaid <<~MERMAID, diagram
      gantt
        title Launch
        dateFormat YYYY-MM-DD
        Kickoff :milestone, kick, 2026-01-05, 1d
        section Build
        Code :crit, code, after kick, 2w
        Ship :ship, after code, 1d
    MERMAID
  end
end
