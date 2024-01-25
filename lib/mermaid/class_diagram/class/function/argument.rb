# frozen_string_literal: true

module Mermaid
  class ClassDiagram::Class::Function::Argument < Dry::Struct
    attribute :name, ClassDiagram::Types::String
    attribute :type, ClassDiagram::Types::String.optional.default(nil)

    def to_s
      if type
        "#{type} #{name}"
      else
        name
      end
    end
  end
end
