# frozen_string_literal: true

module Mermaid
  class SankeyDiagram < BaseDiagram
    KEYWORD = 'sankey-beta'
    def initialize(*)
      raise NotImplementedError, 'SankeyDiagram is not implemented yet'
    end
  end
end
