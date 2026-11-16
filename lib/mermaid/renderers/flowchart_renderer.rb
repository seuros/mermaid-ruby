# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::FlowchartDiagram, top-down.
    class FlowchartRenderer < Renderer
      renders Diagrams::FlowchartDiagram, 'flowchart TD'

      private

      def body = [*diagram.nodes.map { "#{it.id}[#{quote(it.label)}]" }, *diagram.edges.map { edge(it) }]

      def edge(edge)
        arrow = edge.label ? "-->|#{quote(edge.label)}|" : '-->'
        "#{edge.source_id} #{arrow} #{edge.target_id}"
      end
    end
  end
end
