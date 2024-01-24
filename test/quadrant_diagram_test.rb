# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class QuadrantDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { QuadrantDiagram.new }
    end
  end
end
