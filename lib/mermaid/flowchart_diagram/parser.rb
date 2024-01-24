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
            id = $1
            label = $2 || $3 || $4
            shape = $2 ? 'box' : $3 ? 'round' : 'decision'
            nodes << Node.new(id: id, label: label, shape: shape)
          elsif line =~ /^(\S+)\s+-->(?:\|(.*)\|\s+)?(\S+)/
            from = $1
            label = $2
            to = $3
            links << Link.new(from: from, to: to, label: label)
          end
        end
        new(id: 'parsed', direction: direction, nodes: nodes, links: links)
      end
    end
  end
end