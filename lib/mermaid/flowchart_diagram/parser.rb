# frozen_string_literal: true

module Mermaid
  module FlowchartDiagram::Parser
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def parse(input)
        lines = input.split("\n")
        _, direction = lines.shift.split
        nodes = []
        links = []
        lines.each do |line|
          if line =~ /^(\S+)(?:\[(.*)\]|\((.*)\)|\{(.*)\})/
            id = ::Regexp.last_match(1)
            label = ::Regexp.last_match(2) || ::Regexp.last_match(3) || ::Regexp.last_match(4)
            shape = if ::Regexp.last_match(2)
                      'box'
                    else
                      ::Regexp.last_match(3) ? 'round' : 'decision'
                    end
            nodes << Node.new(id:, label:, shape:)
          elsif line =~ /^(\S+)\s+-->(?:\|(.*)\|\s+)?(\S+)/
            from = ::Regexp.last_match(1)
            label = ::Regexp.last_match(2)
            to = ::Regexp.last_match(3)
            links << Link.new(from:, to:, label:)
          end
        end
        new(id: 'parsed', direction:, nodes:, links:)
      end
    end
  end
end
