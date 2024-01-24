# frozen_string_literal: true

module Mermaid
  class StateDiagram < BaseDiagram
    attribute :id, Types::String
    attribute :states, Types::Array.of(State)
    attribute :transitions, Types::Array.of(Transition)
  end
end
