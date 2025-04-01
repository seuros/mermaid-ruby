# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for Diagrams::StateDiagram
  module StateDiagramRenderer
    # @!method to_mermaid
    #   Generates the Mermaid syntax for the state diagram.
    #   @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"stateDiagram-v2\n" # Use mutable string

      # Define states with labels first
      states.each do |state|
        mermaid_string << "  #{state.to_mermaid_fragment}\n" if state.label
      end

      # Add transitions
      transitions.each do |transition|
        mermaid_string << "  #{transition.to_mermaid_fragment}\n"
      end

      mermaid_string.strip # Remove potential trailing newline
    end

    # Patch validation to allow '*' for start/end states used by Mermaid
    private

    def validate_elements!
      # Temporarily filter out transitions involving '*' before calling original validation
      original_transitions = @transitions
      @transitions = original_transitions.reject do |t|
        t.source_state_id == '*' || t.target_state_id == '*'
      end

      # Call original validation using super
      super # Calls Diagrams::StateDiagram#validate_elements!
    ensure
      # Restore original transitions array regardless of validation outcome
      @transitions = original_transitions
    end
  end
end
