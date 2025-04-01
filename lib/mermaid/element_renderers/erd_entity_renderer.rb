# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::ElementRenderers::ERDEntity
    module ERDEntityRenderer
      # Generates the Mermaid fragment for this entity.
      # @return [String] The Mermaid syntax fragment for the entity.
      def to_mermaid_fragment
        fragment = "\"#{name}\" {\n"
        entity_attributes.each do |attr|
          fragment << "  #{attr.type} #{attr.name}"
          # Join keys like PK, FK with spaces if present
          fragment << " #{attr.keys.join(' ')}" unless attr.keys.empty?
          fragment << " \"#{attr.comment}\"" if attr.comment && !attr.comment.empty?
          fragment << "\n"
        end
        fragment << "}\n"
        fragment
      end
    end
  end
end
