# frozen_string_literal: true

module Mermaid
  class StateDiagram::State < Dry::Struct
    attribute :id, StateDiagram::Types::String
    attribute :label, StateDiagram::Types::String.optional.default(nil)
    attribute :type, StateDiagram::Types::String.optional.default('state').enum('state', 'start', 'end', 'fork', 'join')
    def to_s
      if label
        "#{id} : #{label}"
      else
        id
      end
    end
  end
end
