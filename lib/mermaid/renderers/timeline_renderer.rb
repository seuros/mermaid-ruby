# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::TimelineDiagram. A period reads "label : event : event".
    class TimelineRenderer < Renderer
      prepend InlineTitle

      KEYWORDS = %w[title section acctitle accdescr].freeze

      renders Diagrams::TimelineDiagram, 'timeline'

      private

      def body
        diagram.sections.flat_map do |section|
          [*("section #{text(section.title)}" if section.title), *section.periods.map { period(it) }]
        end
      end

      def period(period) = [line_start(period.label, KEYWORDS), *period.events.map { text(it) }].join(' : ')
    end
  end
end
