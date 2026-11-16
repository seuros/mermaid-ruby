# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::StateDiagram. Every state is declared, so a state without
    # transitions still shows. A state id Mermaid cannot read as a plain name
    # is aliased (s0, s1, ...) and shows its label, or its id. A transition
    # reads "label [guard] / action".
    class StateRenderer < Renderer
      RESERVED = %w[state note end as direction classdef class style click hide scale default root_start root_end
                    acctitle accdescr].freeze

      renders Diagrams::StateDiagram, 'stateDiagram-v2'

      private

      def body
        name = names(diagram.states.map(&:id), 's', RESERVED)
        [*diagram.states.map { declaration(it, name[it.id]) }, *diagram.transitions.map { transition(it, name) }]
      end

      def declaration(state, name)
        return %(state "#{text(state.label || state.id)}" as #{name}) unless name == state.id

        state.label ? "#{name} : #{text(state.label)}" : name
      end

      def transition(transition, name)
        node = ->(id) { id == Diagrams::StateDiagram::TERMINAL ? '[*]' : name.fetch(id) }
        line = "#{node[transition.source_state_id]} --> #{node[transition.target_state_id]}"
        label = [transition.label, ("[#{transition.guard}]" if transition.guard),
                 ("/ #{transition.action}" if transition.action)].compact.join(' ')
        label.empty? ? line : "#{line} : #{text(label)}"
      end
    end
  end
end
