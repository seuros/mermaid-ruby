# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class UserJourneyDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~EOS
      journey
          title My working day
          section Go to work
            Make tea: 5: Me
            Go upstairs: 3: Me
            Do work: 1: Me, Cat
          section Go home
            Go downstairs: 5: Me
            Sit down: 5: Me
    EOS
    def test_diagram
      assert_raises(NotImplementedError) { UserJourneyDiagram.new }
    end
  end
end
