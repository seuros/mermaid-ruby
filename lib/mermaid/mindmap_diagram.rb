# frozen_string_literal: true

module Mermaid
  class MindmapDiagram < BaseDiagram
    KEYWORD = 'mindmap'
    def initialize(*)
      raise NotImplementedError, 'MindmapDiagram is not implemented yet'
    end
  end
end
