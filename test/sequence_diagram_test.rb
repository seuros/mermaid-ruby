# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class SequenceDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { SequenceDiagram.new }
    end
  end
end
