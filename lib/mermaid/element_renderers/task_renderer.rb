# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::Elements::Task
    module TaskRenderer
      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a Gantt task.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        "#{name} :#{id}, #{start_date}, #{end_date}"
      end
    end
  end
end
