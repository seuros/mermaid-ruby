# frozen_string_literal: true

module Mermaid
  class GanttDiagram < BaseDiagram
    NAME = 'gantt'

    class Task < Dry::Struct
      attribute :name, GanttDiagram::Types::String
      attribute :start, GanttDiagram::Types::String
      attribute :end, GanttDiagram::Types::String
    end

    class Section < Dry::Struct
      attribute :name, GanttDiagram::Types::String
      attribute :tasks, GanttDiagram::Types::Array.of(Task)
    end

    attribute :title, GanttDiagram::Types::String
    attribute :date_format, GanttDiagram::Types::String.optional.default('YYYY-MM-DD')
    attribute :axis_format, GanttDiagram::Types::String.optional.default('%Y-%m-%d')
    attribute :tick_interval,
              GanttDiagram::Types::String.optional.default(nil).constrained(format: /^([1-9][0-9]*)(millisecond|second|minute|hour|day|week|month)$/)
    attribute :sections, GanttDiagram::Types::Array.of(Section)
  end
end
