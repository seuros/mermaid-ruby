# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class ERDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { ERDiagram.new }
    end
  end
end
