# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::TimelineDiagram. A period reads "label : event : event".
    class TimelineRenderer < Renderer
      prepend InlineTitle

      renders Diagrams::TimelineDiagram, 'timeline'

      private

      def body
        diagram.sections.flat_map do |section|
          [*("section #{section.title}" if section.title), *section.periods.map { [it.label, *it.events].join(' : ') }]
        end
      end
    end
  end
end
