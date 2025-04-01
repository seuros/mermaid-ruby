# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for Diagrams::GanttDiagram
  module GanttDiagramRenderer
    # @!method to_mermaid
    #   Generates the Mermaid syntax for the Gantt chart.
    #   @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"gantt\n"
      mermaid_string << "title #{title}\n" if title && !title.empty?
      sections.each do |section|
        # Always add section title
        mermaid_string << "section #{section.title}\n"
        section.tasks&.each { |task| mermaid_string << task.to_mermaid_fragment << "\n" }
      end
      mermaid_string.strip
    end
  end
end
