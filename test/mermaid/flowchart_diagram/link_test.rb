# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class FlowchartDiagram::LinkTest < DiagramTest

    def test_representation
      link = FlowchartDiagram::Link.new(from: 'A', to: 'B', label: 'Text', style: 'arrow_head')
      assert_equal '-->|Text|', link.representation
    end

    def test_unicode_representation
      link = FlowchartDiagram::Link.new(from: 'A', to: 'B', label: 'We ♥ Unicode', style: 'arrow_head')
      assert_equal '-->|"We ♥ Unicode"|', link.representation
    end
  end
end