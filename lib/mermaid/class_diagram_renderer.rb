# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for Diagrams::ClassDiagram
  module ClassDiagramRenderer
    # @!method to_mermaid
    #   Generates the Mermaid syntax for the class diagram.
    #   @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"classDiagram\n"

      classes.each do |klass|
        fragment = format_class_entity(klass) # Call private helper method
        mermaid_string << fragment.to_s << "\n"
      end

      relationships.each do |rel|
        mermaid_string << rel.to_mermaid_fragment.to_s
      end

      mermaid_string.strip
    end

    private

    # Helper to format ClassEntity for Mermaid
    def format_class_entity(klass)
      diagram = "class #{klass.name}"
      attributes_list = klass[:attributes] || []
      methods_list = klass[:methods] || []
      has_members = attributes_list.any? || methods_list.any?
      diagram += " {\n" if has_members

      attributes_list.each do |attr_str|
        diagram += "  #{attr_str}\n"
      end
      methods_list.each do |method_str|
        diagram += "  #{method_str}\n"
      end

      diagram += "}\n" if has_members
      diagram
    end
  end
end
