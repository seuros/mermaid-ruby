# frozen_string_literal: true

require_relative 'mermaid/version'
require 'zeitwerk'
require 'dry-types'
require 'dry-struct'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'er_diagram' => 'ERDiagram',
  'xy_diagram' => 'XYDiagram'
)
loader.setup

module Mermaid

end
