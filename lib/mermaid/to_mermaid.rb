# frozen_string_literal: true

module Mermaid
  # Included into Diagrams::Base: every diagram renders itself.
  module ToMermaid
    # This diagram as Mermaid text.
    def to_mermaid = Renderer.render(self)
  end
end
