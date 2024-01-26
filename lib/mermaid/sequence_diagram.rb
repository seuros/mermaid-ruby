# frozen_string_literal: true

module Mermaid
  class SequenceDiagram < BaseDiagram
    KEYWORD = 'sequenceDiagram'
    def initialize(*)
      raise NotImplementedError, 'SequenceDiagram is not implemented yet'
    end
  end
end
