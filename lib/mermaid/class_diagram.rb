# frozen_string_literal: true

module Mermaid
  class ClassDiagram < BaseDiagram
    KEYWORD = 'classDiagram'
    attribute :classes, ClassDiagram::Types::Array.of(Class)

    def generate
      diagram = "#{KEYWORD}\n"
      classes.each do |klass|
        diagram += "  #{klass}\n"
      end
      diagram
    end
  end
end
