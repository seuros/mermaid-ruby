# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::FlowchartDiagram, top-down. Node ids Mermaid cannot read as
    # plain names are aliased (n0, n1, ...); every node shows its label.
    class FlowchartRenderer < Renderer
      RESERVED = %w[end graph flowchart subgraph style linkstyle classdef class click call href direction default
                    acctitle accdescr].freeze

      renders Diagrams::FlowchartDiagram, 'flowchart TD'

      private

      def body
        name = names(diagram.nodes.map(&:id), 'n', RESERVED)
        [*diagram.nodes.map { "#{name[it.id]}[#{quote(it.label)}]" },
         *diagram.edges.map { edge(it, name) }]
      end

      def edge(edge, name)
        arrow = edge.label ? "-->|#{quote(edge.label)}|" : '-->'
        "#{name[edge.source_id]} #{arrow} #{name[edge.target_id]}"
      end
    end
  end
end
