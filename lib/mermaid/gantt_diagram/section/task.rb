# frozen_string_literal: true

module Mermaid
  class GanttDiagram
    class Section
      class Task < Dry::Struct
        attribute :name, GanttDiagram::Types::String
        attribute :start, GanttDiagram::Types::String
        attribute :end, GanttDiagram::Types::String
      end
    end
  end
end
