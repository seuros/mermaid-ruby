# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for Diagrams::FlowchartDiagram
  module FlowchartDiagramRenderer
    # @!method to_mermaid
    #   Generates the Mermaid syntax for the flowchart diagram.
    #   @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"graph TD\n"

      nodes.each do |node|
        mermaid_string << "  #{node.to_mermaid_fragment}\n" # Ensure newline after node
      end

      edges.each do |edge|
        mermaid_string << "  #{edge.to_mermaid_fragment}\n" # Ensure newline after edge
      end

      mermaid_string # Return the full string including final newline
    end
  end
end
