# frozen_string_literal: true

require 'test_helper'

class PieRendererTest < Minitest::Test
  def test_title_and_slices
    diagram = Diagrams::PieDiagram.new(title: 'Pets')
    diagram.add_slice(label: 'Dogs', value: 3.0)
    diagram.add_slice(label: 'Cats', value: 1.5)
    diagram.add_slice(label: 'Fish', value: 2)

    assert_mermaid <<~MERMAID, diagram
      pie
        title Pets
        "Dogs" : 3
        "Cats" : 1.5
        "Fish" : 2
    MERMAID
  end
end
