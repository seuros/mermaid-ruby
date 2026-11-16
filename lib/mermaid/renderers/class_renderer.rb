# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::ClassDiagram. Arrows point from the source class (parent,
    # whole, interface) to the target.
    class ClassRenderer < Renderer
      ARROWS = {
        inheritance: '<|--', composition: '*--', aggregation: 'o--', association: '-->',
        dependency: '..>', realization: '<|..', link: '--'
      }.freeze

      renders Diagrams::ClassDiagram, 'classDiagram'

      private

      def body = [*diagram.classes.flat_map { klass(it) }, *diagram.relationships.map { relationship(it) }]

      def klass(entity)
        members = [*entity.attributes, *entity.operations]
        return ["class #{entity.name}"] if members.empty?

        ["class #{entity.name} {", *members.map { "  #{it}" }, '}']
      end

      def relationship(relationship)
        line = "#{relationship.source_class_name} #{ARROWS.fetch(relationship.type)} #{relationship.target_class_name}"
        relationship.label ? "#{line} : #{relationship.label}" : line
      end
    end
  end
end
