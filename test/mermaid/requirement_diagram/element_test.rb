# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class RequirementDiagram
    class ElementTest < DiagramTest
      EXPECTED_OUTPUT = <<~OUTPUT
        element user_defined_name {
        type: user_defined_type
        docref: user_defined_ref
        }
      OUTPUT

      def test_representation
        element = Element.new(
          type: 'user_defined_type',
          name: 'user_defined_name',
          docref: 'user_defined_ref'
        )
        assert_equal EXPECTED_OUTPUT, element.to_s
      end
    end
  end
end
