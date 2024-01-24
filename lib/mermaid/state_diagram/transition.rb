# frozen_string_literal: true

module Mermaid
  class StateDiagram::Transition < Dry::Struct
    attribute :from, StateDiagram::Types::String
    attribute :to, StateDiagram::Types::String
    attribute :label, StateDiagram::Types::String.optional.default(nil)

    def to_s
      if label
        "#{from} --> #{to} : #{label}"
      else
        "#{from} --> #{to}"
      end
    end
  end
end
