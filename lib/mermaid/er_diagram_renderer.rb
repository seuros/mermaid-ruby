# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for ER Diagrams
  module ERDiagramRenderer
    # Generates the Mermaid syntax for the ER diagram.
    # Prepended to Diagrams::ERDiagram.
    # @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"erDiagram\n"

      # Diagrams::ERDiagram stores entities in a hash, access values
      entities.each_value do |entity|
        mermaid_string << entity.to_mermaid_fragment
      end

      relationships.each do |rel|
        mermaid_string << rel.to_mermaid_fragment
      end

      mermaid_string.strip
    end
  end
end
