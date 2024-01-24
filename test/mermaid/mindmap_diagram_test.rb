# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class MindmapDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { MindmapDiagram.new }
    end
  end
end
