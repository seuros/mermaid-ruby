# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::StateDiagram. Every state is declared, so a state without
    # transitions still shows. A transition reads "label [guard] / action".
    class StateRenderer < Renderer
      renders Diagrams::StateDiagram, 'stateDiagram-v2'

      private

      def body
        [*diagram.states.map { [it.id, it.label].compact.join(' : ') }, *diagram.transitions.map { transition(it) }]
      end

      def transition(transition)
        text = [transition.label, ("[#{transition.guard}]" if transition.guard),
                ("/ #{transition.action}" if transition.action)].compact.join(' ')
        line = "#{node(transition.source_state_id)} --> #{node(transition.target_state_id)}"
        text.empty? ? line : "#{line} : #{text}"
      end

      def node(id) = id == Diagrams::StateDiagram::TERMINAL ? '[*]' : id
    end
  end
end
