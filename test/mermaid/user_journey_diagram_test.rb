# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class UserJourneyDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { UserJourneyDiagram.new }
    end
  end
end
