# frozen_string_literal: true

module Mermaid
  module ElementRenderers
    # Module containing Mermaid rendering logic for Diagrams::ElementRenderers::Slice
    module SliceRenderer
      # @!method to_mermaid_fragment
      #   Generates the Mermaid fragment for a pie chart slice.
      #   @return [String] Mermaid syntax fragment.
      def to_mermaid_fragment
        formatted_value = value.to_i == value ? value.to_i : value
        "\"#{label}\" : #{formatted_value}"
      end
    end
  end
end
