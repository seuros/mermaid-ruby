# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class GanttDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~RESULT
      gantt
          title A Gantt Diagram
          dateFormat YYYY-MM-DD
          section Section
              A task          :a1, 2014-01-01, 30d
              Another task    :after a1, 20d
          section Another
              Task in Another :2014-01-12, 12d
              another task    :24d
    RESULT
    def test_diagram
      # assert_raises(NotImplementedError) { GanttDiagram.new }
    end
  end
end
