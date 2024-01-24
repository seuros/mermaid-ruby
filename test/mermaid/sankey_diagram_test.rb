# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class SankeyDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { SankeyDiagram.new }
    end
  end
end
