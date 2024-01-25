# frozen_string_literal: true

module Mermaid
  class ERDiagram::Entity < Dry::Struct
    attribute :name, ERDiagram::Types::String
    attribute :attributes, ERDiagram::Types::Array.of(ERDiagram::Attribute)

    def to_s
      "#{name} {#{attributes.join(', ')}}"
    end
  end
end
