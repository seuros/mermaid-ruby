# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::GanttDiagram. A task reads "label :status, id, start, duration".
    # Ids are referenced from other tasks' start ("after id"), so they render
    # as written: an id, start or duration Mermaid would split or cut is
    # refused.
    class GanttRenderer < Renderer
      prepend InlineTitle

      KEYWORDS = %w[title section dateformat inclusiveenddates topaxis axisformat tickinterval includes excludes
                    todaymarker weekday weekend click call acctitle accdescr].freeze
      ID = /\A[A-Za-z0-9_][A-Za-z0-9_-]*\z/
      DATA = /[,#;\n\r]|%%/

      renders Diagrams::GanttDiagram, 'gantt'

      private

      def body
        diagram.sections.flat_map do |section|
          [*("section #{text(section.title)}" if section.title), *section.tasks.map { task(it) }]
        end
      end

      def task(task)
        raise ArgumentError, "Mermaid cannot use task id #{task.id.inspect}" unless task.id.match?(ID)

        data = [task.start, task.duration].each do |value|
          raise ArgumentError, "Mermaid would split task data #{value.inspect}" if value.match?(DATA)
        end
        "#{line_start(task.label, KEYWORDS)} :#{[task.status, task.id, *data].compact.join(', ')}"
      end
    end
  end
end
