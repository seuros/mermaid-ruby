# frozen_string_literal: true

module Mermaid
  class C4Diagram < BaseDiagram
    KEYWORD = 'C4Context'
    def initialize(*)
      raise NotImplementedError, 'C4Diagram is not implemented yet'
    end
  end
end
