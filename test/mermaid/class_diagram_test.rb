# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class ClassDiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { ClassDiagram.new }
    end
  end
end
