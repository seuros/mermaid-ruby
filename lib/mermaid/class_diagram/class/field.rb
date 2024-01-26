# frozen_string_literal: true

module Mermaid
  class ClassDiagram
    class Class
      class Field < Dry::Struct
        attribute :name, ClassDiagram::Types::String
        attribute :type, ClassDiagram::Types::String.optional.default('String')
        attribute :visibility,
                  ClassDiagram::Types::String.optional.default('public')
                                             .constrained(format: /\A(public|private|protected|Internal)\z/)

        VISIBILITY_SYMBOLS = {
          'public' => '+',
          'private' => '-',
          'protected' => '#',
          'Internal' => '~'
        }.freeze

        def to_s
          # +String owner
          "#{VISIBILITY_SYMBOLS[visibility]}#{type} #{name}"
        end
      end
    end
  end
end
