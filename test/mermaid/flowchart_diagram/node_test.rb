# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class FlowchartDiagram
    class NodeTest < DiagramTest
      def test_representation
        node = FlowchartDiagram::Node.new(id: 'A', label: 'Hard', shape: 'round')
        assert_equal 'A(Hard)', node.to_s
      end

      def test_unicode_representation
        node = FlowchartDiagram::Node.new(id: 'A', label: 'We ♥ Unicode', shape: 'round')
        assert_equal 'A(We ♥ Unicode)', node.to_s
      end
    end
  end
end
