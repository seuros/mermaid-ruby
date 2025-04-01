# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for Diagrams::TimelineDiagram
  module TimelineDiagramRenderer
    # @!method to_mermaid
    #   Generates the Mermaid syntax for the timeline diagram.
    #   @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"timeline\n"
      mermaid_string << "title #{@title}\n" if @title && !@title.empty?

      sections.each do |section|
        # Don't output the default section title if it's the only one and has no specific title
        unless sections.size == 1 && section.title == Diagrams::TimelineDiagram::DEFAULT_SECTION_TITLE
          mermaid_string << "section #{section.title}\n"
        end

        section.periods.each do |period|
          # Format: Period Label : Event 1 : Event 2 ...
          event_descriptions = period.events.map(&:description).join(' : ')
          mermaid_string << "  #{period.label} : #{event_descriptions}\n"
        end
      end

      mermaid_string.strip
    end
  end
end
