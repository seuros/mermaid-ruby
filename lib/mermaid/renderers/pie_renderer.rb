# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::PieDiagram.
    class PieRenderer < Renderer
      prepend InlineTitle

      renders Diagrams::PieDiagram, 'pie'

      private

      def body = diagram.slices.map { "#{quote(it.label)} : #{number(it.value)}" }

      def number(value) = value.is_a?(Float) && (value % 1).zero? ? value.to_i : value
    end
  end
end
