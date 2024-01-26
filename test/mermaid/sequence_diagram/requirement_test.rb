# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class RequirementDiagram
    class RequirementTest < DiagramTest
      EXPECTED_OUTPUT = <<~OUTPUT
        functionalRequirement user_defined_name {
            id: user_defined_id
            text: user_defined text
            risk: high
            verifymethod: analysis
        }
      OUTPUT

      def test_requirement
        requirement = Requirement.new(
          type: 'functionalRequirement',
          name: 'user_defined_name',
          id: 'user_defined_id',
          text: 'user_defined text',
          risk: 'high',
          verifymethod: 'analysis'
        )
        assert_equal EXPECTED_OUTPUT, requirement.to_s
      end
    end
  end
end
