# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::GanttDiagram. A task reads "label :status, id, start, duration".
    class GanttRenderer < Renderer
      prepend InlineTitle

      renders Diagrams::GanttDiagram, 'gantt'

      private

      def body
        diagram.sections.flat_map do |section|
          [*("section #{section.title}" if section.title), *section.tasks.map { task(it) }]
        end
      end

      def task(task) = "#{task.label} :#{[task.status, task.id, task.start, task.duration].compact.join(', ')}"
    end
  end
end
