# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class GitGraphDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { GitGraphDiagram.new }
    end
  end
end
