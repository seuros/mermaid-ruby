# frozen_string_literal: true

module Mermaid
  class RequirementDiagram
    class Relationship < Dry::Struct
      attribute :from, RequirementDiagram::Types::String
      attribute :to, RequirementDiagram::Types::String
      attribute :type,
                RequirementDiagram::Types::String.enum('contains', 'copies', 'derives', 'satisfies', 'verifies',
                                                       'refines', 'traces')

      def to_s
        "#{from} - #{type} -> #{to}"
      end
    end
  end
end
