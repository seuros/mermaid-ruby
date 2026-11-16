# frozen_string_literal: true

require 'test_helper'

class RendererTest < Minitest::Test
  def test_every_diagram_type_has_a_renderer
    Diagrams::Base.subclasses.each do |type|
      assert_kind_of String, type.new.to_mermaid, type.name
    end
  end

  def test_a_diagram_type_without_renderer_is_a_type_error
    type = Class.new(Diagrams::FlowchartDiagram)

    error = assert_raises(TypeError) { type.new.to_mermaid }
    assert_match(/no Mermaid renderer/, error.message)
  end

  def test_title_goes_to_the_front_matter
    assert_mermaid <<~MERMAID, Diagrams::FlowchartDiagram.new(title: 'Say "hi": now')
      ---
      title: "Say \\"hi\\": now"
      ---
      flowchart TD
    MERMAID
  end
end
