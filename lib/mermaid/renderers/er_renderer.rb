# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::ERDiagram. Keys render as Mermaid keys ("PK, FK, UK"), an
    # identifying relationship as a solid line and a non-identifying one
    # dashed. Mermaid requires a relationship label, so a missing one is "".
    class ERRenderer < Renderer
      LEFT = { ZERO_OR_ONE: '|o', ONE_ONLY: '||', ZERO_OR_MORE: '}o', ONE_OR_MORE: '}|' }.freeze
      RIGHT = { ZERO_OR_ONE: 'o|', ONE_ONLY: '||', ZERO_OR_MORE: 'o{', ONE_OR_MORE: '|{' }.freeze

      renders Diagrams::ERDiagram, 'erDiagram'

      private

      def body = [*diagram.entities.flat_map { entity(it) }, *diagram.relationships.map { relationship(it) }]

      def entity(entity)
        return [name(entity.name)] if entity.attributes.empty?

        ["#{name(entity.name)} {", *entity.attributes.map { "  #{attribute(it)}" }, '}']
      end

      def attribute(attribute)
        keys = attribute.keys.join(', ') unless attribute.keys.empty?
        comment = %("#{attribute.comment.tr('"', "'")}") if attribute.comment
        [attribute.type, attribute.name, keys, comment].compact.join(' ')
      end

      def relationship(relationship)
        line = relationship.identifying ? '--' : '..'
        cardinality = "#{LEFT.fetch(relationship.cardinality1)}#{line}#{RIGHT.fetch(relationship.cardinality2)}"
        label = relationship.label.to_s.tr('"', "'")
        %(#{name(relationship.entity1)} #{cardinality} #{name(relationship.entity2)} : "#{label}")
      end

      def name(name) = %("#{name}")
    end
  end
end
