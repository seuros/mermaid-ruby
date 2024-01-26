# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class StateDiagram
    class StateTest < DiagramTest
      def test_state_with_label
        state = StateDiagram::State.new(id: 'Still', label: 'Parked State')
        assert_equal 'Still : Parked State', state.to_s
      end

      def test_state_without_label
        state = StateDiagram::State.new(id: 'Still')
        assert_equal 'Still', state.to_s
      end
    end
  end
end
