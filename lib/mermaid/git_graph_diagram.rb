# frozen_string_literal: true

module Mermaid
  class GitGraphDiagram < BaseDiagram
    KEYWORD = 'gitGraph'
    def initialize(*)
      raise NotImplementedError, 'GitGraphDiagram is not implemented yet'
    end
  end
end
