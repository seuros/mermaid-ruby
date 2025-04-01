# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::Elements::Transition
    module TransitionRenderer
      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a transition.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        from_node = source_state_id == '*' ? '[*]' : source_state_id
        to_node = target_state_id == '*' ? '[*]' : target_state_id
        label ? "#{from_node} --> #{to_node} : #{label}" : "#{from_node} --> #{to_node}"
      end
    end
  end
end
