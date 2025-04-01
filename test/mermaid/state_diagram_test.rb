# frozen_string_literal: true

require 'test_helper'

class StateDiagramStringTest < UnitTest
  def test_empty_diagram
    diagram = Diagrams::StateDiagram.new(states: [], transitions: []) # Removed :id
    expected = <<~MERMAID
      stateDiagram-v2
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_simple_transition
    states = [
      Diagrams::Elements::State.new(id: 'A'),
      Diagrams::Elements::State.new(id: 'B')
    ]
    transitions = [
      Diagrams::Elements::Transition.new(source_state_id: 'A', target_state_id: 'B')
    ]
    diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
    expected = <<~MERMAID
      stateDiagram-v2
        A --> B
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_transition_with_label
    states = [
      Diagrams::Elements::State.new(id: 'A'),
      Diagrams::Elements::State.new(id: 'B')
    ]
    transitions = [
      Diagrams::Elements::Transition.new(source_state_id: 'A', target_state_id: 'B', label: 'Event')
    ]
    diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
    expected = <<~MERMAID
      stateDiagram-v2
        A --> B : Event
    MERMAID
    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_start_and_end_states
    # Define state 'A' explicitly
    states = [Diagrams::Elements::State.new(id: 'A')]
    transitions = [
      # Assuming '*' represents start/end in the diagram gem's Transition
      Diagrams::Elements::Transition.new(source_state_id: '*', target_state_id: 'A'),
      Diagrams::Elements::Transition.new(source_state_id: 'A', target_state_id: '*')
    ]
    # NOTE: Validation might still fail for '*' if not handled by diagram gem
    diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
    expected = <<~MERMAID
      stateDiagram-v2
        [*] --> A
        A --> [*]
    MERMAID
    # Normalize whitespace/newlines for comparison
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_state_with_label
    # State 'State1' is already defined in the states array
    states = [
      Diagrams::Elements::State.new(id: 'State1', label: 'This is state 1')
    ]
    transitions = [
      Diagrams::Elements::Transition.new(source_state_id: '*', target_state_id: 'State1')
    ]
    # NOTE: Validation might still fail for '*'
    diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
    expected = <<~MERMAID
      stateDiagram-v2
        State1 : This is state 1
        [*] --> State1
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  # Add more complex scenarios: forks, joins, nested states (if supported by classes)
end

# class StateDiagramIntegrationTest < IntegrationTest
#   # Tests that run in a headless browser
#   # Temporarily commented out due to flakiness (Ferrum::PendingConnectionsError)
#
#   def test_simple_diagram_renders
#     states = [
#       Diagrams::Elements::State.new(id: 'A'),
#       Diagrams::Elements::State.new(id: 'B')
#     ]
#     transitions = [Diagrams::Elements::Transition.new(source_state_id: 'A', target_state_id: 'B')]
#     diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
#     mermaid_string = diagram.to_mermaid
#
#     assert render_mermaid_and_check_errors(mermaid_string), 'Diagram should render without errors'
#   end
#
#   def test_labeled_transition_renders
#     states = [
#       Diagrams::Elements::State.new(id: 'A'),
#       Diagrams::Elements::State.new(id: 'B')
#     ]
#     transitions = [Diagrams::Elements::Transition.new(source_state_id: 'A', target_state_id: 'B', label: 'Click')]
#     diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
#     mermaid_string = diagram.to_mermaid
#
#     assert render_mermaid_and_check_errors(mermaid_string),
#            'Diagram with labeled transition should render without errors'
#   end
#
#   def test_start_end_renders
#     states = [Diagrams::Elements::State.new(id: 'A')]
#     transitions = [
#       Diagrams::Elements::Transition.new(source_state_id: '*', target_state_id: 'A'),
#       Diagrams::Elements::Transition.new(source_state_id: 'A', target_state_id: '*')
#     ]
#     # Note: Validation might still fail for '*'
#     diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
#     mermaid_string = diagram.to_mermaid
#
#     assert render_mermaid_and_check_errors(mermaid_string), 'Diagram with start/end states should render without errors'
#   end
#
#   def test_labeled_state_renders
#     # State 'S1' is already defined
#     states = [Diagrams::Elements::State.new(id: 'S1', label: 'First State')]
#     transitions = [Diagrams::Elements::Transition.new(source_state_id: '*', target_state_id: 'S1')]
#     # Note: Validation might still fail for '*'
#     diagram = Diagrams::StateDiagram.new(states: states, transitions: transitions)
#     mermaid_string = diagram.to_mermaid
#
#     assert render_mermaid_and_check_errors(mermaid_string), 'Diagram with labeled state should render without errors'
#   end
#
#   # Add more complex rendering tests here
# end
