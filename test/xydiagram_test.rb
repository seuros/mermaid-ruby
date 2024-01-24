# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class XYDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { XYDiagram.new }
    end
  end
end
