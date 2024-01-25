# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class PieDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~RESULT
      pie title Pets adopted by volunteers
          "Dogs" : 386
          "Cats" : 85
          "Rats" : 15
    RESULT
    def test_diagram
      assert_raises(NotImplementedError) { PieDiagram.new }
    end
  end
end
