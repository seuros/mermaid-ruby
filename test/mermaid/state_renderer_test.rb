# frozen_string_literal: true

require 'test_helper'

class StateRendererTest < Minitest::Test
  def test_states_and_transitions
    diagram = Diagrams::StateDiagram.new
    diagram.add_state(id: 'closed')
    diagram.add_state(id: 'open', label: 'Open')
    diagram.add_state(id: 'broken')
    diagram.add_transition(source_state_id: '*', target_state_id: 'closed')
    diagram.add_transition(source_state_id: 'closed', target_state_id: 'open', label: 'push')
    diagram.add_transition(source_state_id: 'open', target_state_id: 'closed', guard: 'empty', action: 'lock')
    diagram.add_transition(source_state_id: 'open', target_state_id: '*')

    assert_mermaid <<~MERMAID, diagram
      stateDiagram-v2
        closed
        open : Open
        broken
        [*] --> closed
        closed --> open : push
        open --> closed : [empty] / lock
        open --> [*]
    MERMAID
  end
end
