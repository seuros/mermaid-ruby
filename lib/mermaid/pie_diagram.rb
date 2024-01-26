# frozen_string_literal: true

module Mermaid
  class PieDiagram < BaseDiagram
    KEYWORD = 'pie'
    def initialize(*)
      raise NotImplementedError, 'PieDiagram is not implemented yet'
    end
  end
end
