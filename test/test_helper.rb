# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'mermaid'
Zeitwerk::Loader.eager_load_all

require 'minitest/autorun'

class DiagramTest < Minitest::Test
end
