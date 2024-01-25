# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class SequenceDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~EOS
      sequenceDiagram
        Alice->>John: Hello John, how are you?
        John-->>Alice: Great!
        Alice-)John: See you later!
    EOS
    def test_diagram
      assert_raises(NotImplementedError) { SequenceDiagram.new }
    end
  end
end
