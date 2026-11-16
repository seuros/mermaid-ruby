# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require 'mermaid'

# Base test class for standard unit tests
class UnitTest < Minitest::Test
end
