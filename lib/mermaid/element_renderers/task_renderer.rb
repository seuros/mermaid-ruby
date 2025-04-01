# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::ElementRenderers::Task
    module TaskRenderer
      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a Gantt task.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        "#{label} :#{id}, #{start}, #{duration}"
      end
    end
  end
end
