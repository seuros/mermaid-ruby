# frozen_string_literal: true

require 'test_helper'

class TestMermaid < DiagramTest
  def test_that_it_has_a_version_number
    refute_nil ::Mermaid::VERSION
  end
end
