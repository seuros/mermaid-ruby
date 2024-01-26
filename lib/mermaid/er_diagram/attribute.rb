# frozen_string_literal: true

module Mermaid
  class ERDiagram
    class Attribute < Dry::Struct
      attribute :name, ERDiagram::Types::String
      attribute :type, ERDiagram::Types::String

      def to_s
        "#{type} #{name}"
      end
    end
  end
end
