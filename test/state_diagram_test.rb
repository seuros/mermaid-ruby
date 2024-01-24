# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class StateDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { StateDiagram.new }
    end
  end
end
