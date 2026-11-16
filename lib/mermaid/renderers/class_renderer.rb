# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::ClassDiagram. Arrows point from the source class (parent,
    # whole, interface) to the target. A class name Mermaid cannot read as a
    # plain name is aliased (c0, c1, ...) and shown as its label. Members are
    # Mermaid member notation ("+String name", "+save() bool") and render as
    # written; Mermaid tells operations from attributes by their parentheses,
    # so a member it would misfile, or one that would break the class block,
    # is refused.
    class ClassRenderer < Renderer
      ARROWS = {
        inheritance: '<|--', composition: '*--', aggregation: 'o--', association: '-->',
        dependency: '..>', realization: '<|..', link: '--'
      }.freeze
      RESERVED = %w[class namespace note style classdef cssclass callback call link click direction end default o
                    acctitle accdescr].freeze
      OPERATION = /\(.*\)/

      renders Diagrams::ClassDiagram, 'classDiagram'

      private

      # Mermaid rejects a class diagram without statements.
      def body
        name = names(diagram.classes.map(&:name), 'c', RESERVED)
        lines = [*diagram.classes.flat_map { klass(it, name[it.name]) },
                 *diagram.relationships.map { relationship(it, name) }]
        lines.empty? ? ['direction TB'] : lines
      end

      def klass(entity, name)
        head = name == entity.name ? "class #{name}" : "class #{name}[#{quote(entity.name)}]"
        members = [*entity.attributes.map { member(it, false) }, *entity.operations.map { member(it, true) }]
        members.empty? ? [head] : ["#{head} {", *members.map { "  #{it}" }, '}']
      end

      def member(member, operation)
        raise ArgumentError, "Mermaid cannot show class member #{member.inspect}" if member.match?(/[{}\n\r]/)
        unless member.match?(OPERATION) == operation
          raise ArgumentError, "Mermaid would show #{member.inspect} as an #{operation ? 'attribute' : 'operation'}"
        end

        member
      end

      def relationship(relationship, name)
        line = "#{name[relationship.source_class_name]} #{ARROWS.fetch(relationship.type)} " \
               "#{name[relationship.target_class_name]}"
        relationship.label ? "#{line} : #{text(relationship.label)}" : line
      end
    end
  end
end
