# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::Elements::State
    module StateRenderer
      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a state definition.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        label ? "#{id} : #{label}" : id
      end
    end
  end
end
