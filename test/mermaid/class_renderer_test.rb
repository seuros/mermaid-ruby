# frozen_string_literal: true

require 'test_helper'

class ClassRendererTest < Minitest::Test
  def test_classes_and_relationships
    diagram = Diagrams::ClassDiagram.new
    diagram.add_class(name: 'Animal', attributes: ['+String name'], operations: ['+speak() String'])
    diagram.add_class(name: 'Duck')
    diagram.add_relationship(source_class_name: 'Animal', target_class_name: 'Duck', type: :inheritance)
    diagram.add_relationship(source_class_name: 'Duck', target_class_name: 'Animal', type: :association,
                             label: 'flocks')

    assert_mermaid <<~MERMAID, diagram
      classDiagram
        class Animal {
          +String name
          +speak() String
        }
        class Duck
        Animal <|-- Duck
        Duck --> Animal : flocks
    MERMAID
  end

  def test_every_relationship_type_has_an_arrow
    assert_equal Diagrams::Elements::Relationship::TYPES, Mermaid::Renderers::ClassRenderer::ARROWS.keys
  end
end
