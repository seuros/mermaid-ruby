# frozen_string_literal: true

module Mermaid
  class StateDiagram < BaseDiagram
    KEYWORD = 'stateDiagram-v2'

    attribute :id, Types::String
    attribute :states, Types::Array.of(State)
    attribute :transitions, Types::Array.of(Transition)

    def generate
      diagram = "#{KEYWORD}\n"
      transitions.each do |transition|
        diagram += "  #{transition}\n"
      end
      diagram
    end
  end
end
