# frozen_string_literal: true

module Mermaid
  class RequirementDiagram
    class Element < Dry::Struct
      attribute :type, RequirementDiagram::Types::String.default('requirement')
      attribute :name, RequirementDiagram::Types::String
      attribute :docref, RequirementDiagram::Types::String.optional.default(nil)

      def to_s
        # element user_defined_name {
        #     type: user_defined_type
        #     docref: user_defined_ref
        # }
        <<~OUTPUT
          element #{name} {
          type: #{type}
          docref: #{docref}
          }
        OUTPUT
      end
    end
  end
end
