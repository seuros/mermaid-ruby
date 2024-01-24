# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class C4DiagramTest < DiagramTest
    def test_diagram
      assert_raises(NotImplementedError) { C4Diagram.new }
    end
  end
end
