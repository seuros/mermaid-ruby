# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for Diagrams::PieDiagram
  module PieDiagramRenderer
    # @!method to_mermaid
    #   Generates the Mermaid syntax for the pie chart.
    #   @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"pie\n"
      mermaid_string << "title #{@title}\n" if @title && !@title.empty?
      slices.each { |slice| mermaid_string << slice.to_mermaid_fragment << "\n" }
      mermaid_string.strip
    end
  end
end
