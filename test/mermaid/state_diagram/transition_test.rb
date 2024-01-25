# frozen_string_literal: true

module Mermaid
  class StateDiagram::TransitionTest < DiagramTest
    def test_transition_with_label
      transition = StateDiagram::Transition.new(from: 'Still', to: 'Moving', label: 'Ignition')
      assert_equal 'Still --> Moving : Ignition', transition.to_s
    end

    def test_transition_without_label
      transition = StateDiagram::Transition.new(from: 'Still', to: 'Moving')
      assert_equal 'Still --> Moving', transition.to_s
    end
  end
end
