# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::ElementRenderers::ERDRelationship
    module ERDRelationshipRenderer
      # Maps cardinality symbols from Diagrams::ElementRenderers::ERDRelationship::CARDINALITY
      # to Mermaid syntax (using right-side convention).
      CARDINALITY_MAP = {
        ZERO_OR_ONE: 'o|',
        ONE_ONLY: '||',
        ZERO_OR_MORE: 'o{', # Corrected based on Mermaid docs
        ONE_OR_MORE: '|{' # Corrected based on Mermaid docs
      }.freeze

      # Generates the Mermaid fragment for this relationship.
      # @return [String] The Mermaid syntax fragment for the relationship.
      def to_mermaid_fragment
        # Fetch symbols, raise error if invalid key (shouldn't happen if Diagrams gem validates)
        left_symbol_raw = CARDINALITY_MAP.fetch(cardinality1)
        right_symbol = CARDINALITY_MAP.fetch(cardinality2)

        # Generate the left symbol by mirroring the right-side convention
        left_symbol = case left_symbol_raw
                      when 'o{' then '}o' # Mirror zero or more
                      when '|{' then '}|' # Mirror one or more
                      else left_symbol_raw.reverse # Simple reverse for |o and ||
                      end

        # Always use '--' based on user feedback for compatibility
        id_symbol = '--'

        fragment = "\"#{entity1}\" "
        fragment << left_symbol  # e.g., |o
        fragment << id_symbol    # e.g., --
        fragment << right_symbol # e.g., }|
        fragment << " \"#{entity2}\""
        fragment << " : \"#{label}\"" if label && !label.strip.empty?
        fragment << "\n"
        fragment
      end
    end
  end
end
