# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class MindmapDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~RESULT
      mindmap
        root((mindmap))
          Origins
            Long history
            ::icon(fa fa-book)
            Popularisation
              British popular psychology author Tony Buzan
          Research
            On effectiveness<br/>and features
            On Automatic creation
              Uses
                  Creative techniques
                  Strategic planning
                  Argument mapping
          Tools
            Pen and paper
            Mermaid
    RESULT
    def test_diagram
      assert_raises(NotImplementedError) { MindmapDiagram.new }
    end
  end
end
