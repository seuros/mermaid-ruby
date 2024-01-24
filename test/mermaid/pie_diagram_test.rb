# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class PieDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { PieDiagram.new }
    end
  end
end
