# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class GitGraphDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~RESULT
      gitGraph
         commit
         commit
         branch develop
         checkout develop
         commit
         commit
         checkout main
         merge develop
         commit
         commit
    RESULT
    def test_diagram
      assert_raises(NotImplementedError) { GitGraphDiagram.new }
    end
  end
end
