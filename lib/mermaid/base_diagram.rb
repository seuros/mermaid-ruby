# frozen_string_literal: true

module Mermaid
  class BaseDiagram < Dry::Struct
    module Types
      include Dry.Types()
    end

    def to_s
      generate
    end
  end
end
