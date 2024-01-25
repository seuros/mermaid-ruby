# frozen_string_literal: true

require 'test_helper'

module Mermaid
  class ERDiagramTest < DiagramTest
    EXPECTED_RESULT = <<~RESULT
      erDiagram
          CUSTOMER ||--o{ ORDER : places
          ORDER ||--|{ LINE-ITEM : contains
          CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
    RESULT
    def test_diagram
      assert_raises(NotImplementedError) { ERDiagram.new }
    end
  end
end
