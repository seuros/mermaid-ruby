# frozen_string_literal: true

module Mermaid
  class ClassDiagram::Class::Function < Dry::Struct
    attribute :name, ClassDiagram::Types::String
    attribute :return_type, ClassDiagram::Types::String.optional.default('void')
    attribute :arguments, ClassDiagram::Types::Array.of(Argument)
    attribute :visibility,
              ClassDiagram::Types::String.optional.default('public')
                                         .constrained(format: /\A(public|private|protected)\z/)

    VISIBILITY_SYMBOLS = {
      'public' => '+',
      'private' => '-',
      'protected' => '#'
    }.freeze

    def to_s
      # +String getOwner()
      "#{VISIBILITY_SYMBOLS[visibility]}#{name}(#{arguments.join(', ')}) #{return_type}"
    end
  end
end
