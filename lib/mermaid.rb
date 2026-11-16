# frozen_string_literal: true

require 'diagram'
require 'zeitwerk'
require_relative 'mermaid/version'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('er_renderer' => 'ERRenderer')
loader.setup
# Renderers register themselves for their diagram class as they load.
loader.eager_load

# Mermaid text for the diagrams of the diagram gem: diagram.to_mermaid.
module Mermaid
end

Diagrams::Base.include(Mermaid::ToMermaid)
