# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class RequirementDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~RESULT
      requirementDiagram

      requirement test_req {
      id: 1
      text: the test text.
      risk: high
      verifymethod: test
      }

      element test_entity {
      type: simulation
      }

      test_entity - satisfies -> test_req
    RESULT
    def test_diagram
      assert_raises(NotImplementedError) { RequirementDiagram.new }
    end
  end
end
