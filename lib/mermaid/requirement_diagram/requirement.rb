# frozen_string_literal: true

module Mermaid
  class RequirementDiagram
    class Requirement < Dry::Struct
      Type = RequirementDiagram::Types::String.default('requirement').enum('requirement', 'functionalRequirement',
                                                                           'interfaceRequirement', 'performanceRequirement', 'physicalRequirement', 'designConstraint')
      Risk = RequirementDiagram::Types::String.default('low').enum('low', 'medium', 'high')
      VerificationMethod = RequirementDiagram::Types::String.default('inspection').enum('inspection', 'analysis',
                                                                                        'demonstration', 'test')
      attribute :type, Type
      attribute :name, RequirementDiagram::Types::String
      attribute :id, RequirementDiagram::Types::String
      attribute :text, RequirementDiagram::Types::String
      attribute :risk, Risk
      attribute :verifymethod, VerificationMethod
      def to_s
        <<~OUTPUT
          #{type} #{name} {
              id: #{id}
              text: #{text}
              risk: #{risk}
              verifymethod: #{verifymethod}
          }
        OUTPUT
      end
    end
  end
end
