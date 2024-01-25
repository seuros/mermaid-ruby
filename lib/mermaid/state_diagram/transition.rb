# frozen_string_literal: true

module Mermaid
  class StateDiagram::Transition < Dry::Struct
    attribute :from, StateDiagram::Types::String
    attribute :to, StateDiagram::Types::String
    attribute :label, StateDiagram::Types::String.optional.default(nil)

    def from_representation
      if from == 'start'
        '[*]'
      else
        from
      end
    end

    def to_representation
      if to == 'end'
        '[*]'
      else
        to
      end
    end
    def to_s
      if label
        "#{from_representation} --> #{to_representation} : #{label}"
      else
        "#{from_representation} --> #{to_representation}"
      end
    end
  end
end
