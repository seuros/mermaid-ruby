# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::Elements::Edge
    module EdgeRenderer
      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a flowchart edge.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        if label && !label.empty?
          "#{source_id} -- \"#{label}\" --> #{target_id}"
        else
          "#{source_id} --> #{target_id}"
        end
      end
    end
  end
end
