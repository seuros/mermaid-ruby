# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class RequirementDiagram
    class RelationshipTest < DiagramTest
      EXPECTED_OUTPUT = 'test_entity - satisfies -> test_req2'

      def test_representation
        relationship = Relationship.new(
          from: 'test_entity',
          to: 'test_req2',
          type: 'satisfies'
        )
        assert_equal EXPECTED_OUTPUT, relationship.to_s
      end
    end
  end
end
