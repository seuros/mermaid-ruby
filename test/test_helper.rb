# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require 'mermaid'

# Assertions shared by the renderer tests.
module MermaidAssertions
  def assert_mermaid(expected, diagram)
    assert_equal expected.chomp, diagram.to_mermaid
  end
end

Minitest::Test.include(MermaidAssertions)
