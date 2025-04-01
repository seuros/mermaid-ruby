# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::Elements::Node
    module NodeRenderer
      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a flowchart node.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        escaped_label = label.gsub('"', '#quot;')
        "#{id}[\"#{escaped_label}\"]"
      end
    end
  end
end
