# frozen_string_literal: true

module Mermaid
  class StateDiagram::StateTest < DiagramTest
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
