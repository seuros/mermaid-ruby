# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::GanttDiagram. A task reads "label :status, id, start, duration";
    # the model already holds them in the forms Mermaid evaluates.
    class GanttRenderer < Renderer
      prepend InlineTitle

      KEYWORDS = %w[title section dateformat inclusiveenddates topaxis axisformat tickinterval includes excludes
                    todaymarker weekday weekend click call acctitle accdescr].freeze

      renders Diagrams::GanttDiagram, 'gantt'

      private

      def body
        diagram.sections.flat_map do |section|
          [*("section #{text(section.title)}" if section.title), *section.tasks.map { task(it) }]
        end
      end

      def task(task)
        "#{line_start(task.label, KEYWORDS)} :#{[task.status, task.id, task.start, task.duration].compact.join(', ')}"
      end
    end
  end
end
