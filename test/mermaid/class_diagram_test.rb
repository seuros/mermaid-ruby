# frozen_string_literal: true

require 'test_helper'

class ClassDiagramStringTest < UnitTest
  # --- Test Class Definitions ---

  def test_empty_diagram
    diagram = Diagrams::ClassDiagram.new(classes: [], relationships: [])
    expected = 'classDiagram'

    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_single_class
    klass = Diagrams::Elements::ClassEntity.new(name: 'Animal', members: []) # Use :name instead of :id
    diagram = Diagrams::ClassDiagram.new(classes: [klass], relationships: [])
    expected = <<~MERMAID
      classDiagram
      class Animal
    MERMAID
    # Normalize whitespace/newlines
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_class_with_label
    # ClassEntity does not have :label, only :name
    klass = Diagrams::Elements::ClassEntity.new(name: 'Vehicle', attributes: [], methods: [])
    diagram = Diagrams::ClassDiagram.new(classes: [klass], relationships: [])
    expected = <<~MERMAID
      classDiagram
      class Vehicle
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_class_with_attributes
    # Pass attributes as pre-formatted strings
    attributes = [
      '-int age',
      '+String name'
    ]
    klass = Diagrams::Elements::ClassEntity.new(name: 'Person', attributes: attributes, methods: [])
    diagram = Diagrams::ClassDiagram.new(classes: [klass], relationships: [])
    expected = <<~MERMAID
      classDiagram
      class Person {
        -int age
        +String name
      }
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_class_with_methods
    # Pass methods as pre-formatted strings
    methods = [
      '+getName() String',
      '-setAge(int newAge) void'
    ]
    klass = Diagrams::Elements::ClassEntity.new(name: 'User', attributes: [], methods: methods)
    diagram = Diagrams::ClassDiagram.new(classes: [klass], relationships: [])
    expected = <<~MERMAID
      classDiagram
      class User {
        +getName() String
        -setAge(int newAge) void
      }
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_class_with_attributes_and_methods
    attributes = ['+String breed']
    methods = ['+bark() void']
    klass = Diagrams::Elements::ClassEntity.new(name: 'Dog', attributes: attributes, methods: methods)
    diagram = Diagrams::ClassDiagram.new(classes: [klass], relationships: [])
    expected = <<~MERMAID
      classDiagram
      class Dog {
        +String breed
        +bark() void
      }
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  # --- Test Relationships ---

  def test_inheritance_relationship
    classes = [
      Diagrams::Elements::ClassEntity.new(name: 'Animal', members: []), # Use :name
      Diagrams::Elements::ClassEntity.new(name: 'Dog', members: []) # Use :name
    ]
    relationships = [
      Diagrams::Elements::Relationship.new(source_class_name: 'Dog', target_class_name: 'Animal', type: 'inheritance') # Use correct keys
    ]
    diagram = Diagrams::ClassDiagram.new(classes: classes, relationships: relationships)
    expected = <<~MERMAID
      classDiagram
      class Animal
      class Dog
      Dog <|-- Animal
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_composition_relationship
    classes = [
      Diagrams::Elements::ClassEntity.new(name: 'Wheel', members: []), # Use :name
      Diagrams::Elements::ClassEntity.new(name: 'Car', members: [])    # Use :name
    ]
    relationships = [
      Diagrams::Elements::Relationship.new(source_class_name: 'Car', target_class_name: 'Wheel', type: 'composition') # Use correct keys
    ]
    diagram = Diagrams::ClassDiagram.new(classes: classes, relationships: relationships)
    expected = <<~MERMAID
      classDiagram
      class Wheel
      class Car
      Car *-- Wheel
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_association_relationship_with_label
    classes = [
      Diagrams::Elements::ClassEntity.new(name: 'User', members: []), # Use :name
      Diagrams::Elements::ClassEntity.new(name: 'Order', members: []) # Use :name
    ]
    relationships = [
      Diagrams::Elements::Relationship.new(source_class_name: 'User', target_class_name: 'Order', type: 'association', label: 'places') # Use correct keys
    ]
    diagram = Diagrams::ClassDiagram.new(classes: classes, relationships: relationships)
    expected = <<~MERMAID
      classDiagram
      class User
      class Order
      User --> Order : places
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  # Add tests for aggregation, dependency, realization, link if needed
end
