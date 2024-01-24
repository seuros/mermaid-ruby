# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class RequirementDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { RequirementDiagram.new }
    end
  end
end
