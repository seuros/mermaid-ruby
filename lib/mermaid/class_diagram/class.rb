# frozen_string_literal: true

module Mermaid
  class ClassDiagram::Class < Dry::Struct
    NAME = 'class'

    attribute :id, ClassDiagram::Types::String.constrained(format: /\A[a-zA-Z0-9_-]+\z/)
    attribute :label, ClassDiagram::Types::String.optional.default(nil)
    attribute :fields, ClassDiagram::Types::Array.of(Field)
    attribute :functions, ClassDiagram::Types::Array.of(Function)
    def to_s
      diagram = if label
                  "#{NAME} #{id}[\"#{label}\"]"
                else
                  "#{NAME} #{id}"
                end
      diagram += ' {' if fields.any?
      fields.each do |field|
        diagram += "\n    #{field}"
      end
      functions.each do |function|
        diagram += "\n    #{function}"
      end
      diagram += "\n    }" if fields.any?
      diagram
    end
  end
end
