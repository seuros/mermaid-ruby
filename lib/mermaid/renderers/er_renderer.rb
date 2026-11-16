# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::ERDiagram. Entity names are quoted, keys render as Mermaid keys
    # ("PK, FK, UK"), an identifying relationship as a solid line and a
    # non-identifying one dashed. Mermaid requires a relationship label, so a
    # missing one is "".
    class ERRenderer < Renderer
      LEFT = { ZERO_OR_ONE: '|o', ONE_ONLY: '||', ZERO_OR_MORE: '}o', ONE_OR_MORE: '}|' }.freeze
      RIGHT = { ZERO_OR_ONE: 'o|', ONE_ONLY: '||', ZERO_OR_MORE: 'o{', ONE_OR_MORE: '|{' }.freeze
      # An attribute type or name Mermaid reads bare; others go in backticks.
      WORD = /\A[*A-Za-z_][A-Za-z0-9\-_\[\]().,*]*\z/

      renders Diagrams::ERDiagram, 'erDiagram'

      private

      def body = [*diagram.entities.flat_map { entity(it) }, *diagram.relationships.map { relationship(it) }]

      def entity(entity)
        return [quote(entity.name)] if entity.attributes.empty?

        ["#{quote(entity.name)} {", *entity.attributes.map { "  #{attribute(it)}" }, '}']
      end

      def attribute(attribute)
        keys = attribute.keys.join(', ') unless attribute.keys.empty?
        [word(attribute.type), word(attribute.name), keys,
         (quote(attribute.comment) if attribute.comment)].compact.join(' ')
      end

      def word(value) = value.match?(WORD) ? value : "`#{text(value)}`"

      def relationship(relationship)
        line = relationship.identifying ? '--' : '..'
        cardinality = "#{LEFT.fetch(relationship.cardinality1)}#{line}#{RIGHT.fetch(relationship.cardinality2)}"
        label = quote(relationship.label.to_s)
        "#{quote(relationship.entity1)} #{cardinality} #{quote(relationship.entity2)} : #{label}"
      end
    end
  end
end
