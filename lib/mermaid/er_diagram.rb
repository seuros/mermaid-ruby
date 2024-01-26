# frozen_string_literal: true

module Mermaid
  class ERDiagram < BaseDiagram
    KEYWORD = 'erDiagram'
    def initialize(*)
      raise NotImplementedError, 'ERDiagram is not implemented yet'
    end
  end
end
