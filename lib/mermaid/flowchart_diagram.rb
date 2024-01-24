# frozen_string_literal: true

module Mermaid
  class FlowchartDiagram < BaseDiagram
    include Parser
    NAME = 'flowchart'
    Direction = Types::String.default('LR').enum('LR', 'RL', 'TB', 'BT')
    attribute :id, Types::String
    attribute :direction, Direction
    attribute :nodes, Types::Array.of(Node)
    attribute :links, Types::Array.of(Link)

    def generate
      diagram = "#{NAME} #{direction}\n"
      labeled_nodes = Set.new
      links.each do |link|
        from_node = nodes.find { |node| node.id == link.from }
        to_node = nodes.find { |node| node.id == link.to }
        from_node_already_labeled = !labeled_nodes.include?(from_node)
        to_node_already_labeled = !labeled_nodes.include?(to_node)
        diagram += "  #{from_node.to_s(from_node_already_labeled)} -->#{link.label ? "|#{link.label}|" : ''} #{to_node.to_s(to_node_already_labeled)}\n"
        labeled_nodes << from_node if from_node.label
        labeled_nodes << to_node if to_node.label
      end
      diagram
    end

    def inspect
      "#<#{self.class.name}: Nodes: #{nodes.size}, Links: #{links.size}>"
    end
  end
end
