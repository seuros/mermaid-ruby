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

          # Separate Mermaid-native constraints from comment-only constraints
          unless attr.keys.empty?
            native_keys = attr.keys.select { |key| %i[PK FK].include?(key) }
            comment_keys = attr.keys.select { |key| [:UK].include?(key) }

            # Add native keys first
            fragment << " #{native_keys.join(' ')}" unless native_keys.empty?

            # Quote UK as comment to mark it as comment
            comment_keys.each do |key|
              fragment << " \"#{key}\""
            end
          end

          # Add explicit comment if present
          fragment << " \"#{attr.comment}\"" if attr.comment && !attr.comment.empty?
          fragment << "\n"
        end
        fragment << "}\n"
        fragment
      end
    end
  end
end
