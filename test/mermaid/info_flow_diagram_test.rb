# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class InfoFlowDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { InfoFlowDiagram.new }
    end
  end
end
