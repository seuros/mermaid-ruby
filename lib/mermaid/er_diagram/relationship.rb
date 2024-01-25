# frozen_string_literal: true

module Mermaid
  class ERDiagram::Relationship < Dry::Struct
    attribute :name, ERDiagram::Types::String
    attribute :from, ERDiagram::Types::String
    attribute :to, ERDiagram::Types::String
    attribute :label, ERDiagram::Types::String.optional.default(nil)

    def to_s
      "#{name} {#{entities.join(', ')}}"
    end
  end
end
