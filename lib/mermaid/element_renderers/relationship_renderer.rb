# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::ElementRenderers::Relationship
    module RelationshipRenderer
      # Maps relationship type strings to Mermaid symbols
      MERMAID_RELATIONSHIP_MAP = {
        'inheritance' => '<|--', 'composition' => '*--', 'aggregation' => 'o--',
        'association' => '-->', 'dependency' => '..>', 'realization' => '<|..',
        'link' => '--'
      }.freeze

      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a relationship.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        arrow = MERMAID_RELATIONSHIP_MAP[type] || '--'
        label_str = label ? " : #{label}" : ''
        "#{source_class_name} #{arrow} #{target_class_name}#{label_str}\n"
      end
    end
  end
end
