# frozen_string_literal: true

module Mermaid
  class FlowchartDiagram::Node < Dry::Struct
    SHAPES = %w(default round stadium subroutine database circle double_circle asymmetric rhombus hexagon parallelogram parallelogram_alt trapezoid trapezoid_alt).freeze

    SHAPE_FORMATS = {
      'default' => "%s[%s]", # A[Hard
      'round' => "%s(%s)", # A(Hard)
      'stadium' => "%s([%s])", # A([Hard])
      'subroutine' => "%s[[%s]]", # A([[Hard]])
      'database' => "%s[(%s)]", # A[(Hard)]
      'circle' => "%s((%s))", # A((Hard))
      'double_circle' => "%s(((%s)))", # A(((Hard)))
      'asymmetric' => "%s>%s]", # A>Hard]
      'rhombus' => "%s{%s}", # A{Hard}
      'hexagon' => "%s{{%s}}", # A{{Hard}}
      'parallelogram' => "%s[/%s/]", # A[/Hard/]
      'parallelogram_alt' => "%s[\\%s\\]", # A[\Hard\]
      'trapezoid' => "%s[/%s\\]", # A[/Hard\]
      'trapezoid_alt' => "%s[\\%s/]" # A[\Hard/]
    }.freeze

    attribute :id, FlowchartDiagram::Types::String
    attribute :label, FlowchartDiagram::Types::String
    attribute :shape, FlowchartDiagram::Types::String.default('default').enum(*SHAPES)

    def to_s(show_label = true)
      if show_label
        format(SHAPE_FORMATS[shape], id, label)
      else
        id
      end
    end
  end
end