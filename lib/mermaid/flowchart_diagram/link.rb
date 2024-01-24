# frozen_string_literal: true

module Mermaid
  class FlowchartDiagram::Link < Dry::Struct
    attribute :from, FlowchartDiagram::Types::String
    attribute :to, FlowchartDiagram::Types::String
    attribute :label, FlowchartDiagram::Types::String.optional.default(nil)
    attribute :type, FlowchartDiagram::Types::String.default('arrow_head')
                                                    .enum('arrow_head',
                                                          'open_link',
                                                          'text_link',
                                                          'dotted',
                                                          'thick',
                                                          'invisible'
                                                    )

    def representation
      case type
      when 'arrow_head'
        if label.nil?
          '-->'
        else
          "-->|#{label_representation}|"
        end
      end
    end

    def label_representation
      ## if label is unicode return it with quotes
      ## else return it without quotes
      if label.nil?
        ''
      else
        if label.ascii_only?
          label
        else
          "\"#{label}\""
        end
      end
    end

    def to_s
       [from, representation, to].join
    end
  end
end