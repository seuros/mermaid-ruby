# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class GanttDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { GanttDiagram.new }
    end
  end
end
