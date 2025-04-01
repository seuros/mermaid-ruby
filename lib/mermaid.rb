# frozen_string_literal: true

require_relative 'mermaid/version'
require 'diagrams'

loader = Zeitwerk::Loader.for_gem # Remove Zeitwerk setup
loader.setup

module Diagrams
  StateDiagram.prepend(Mermaid::StateDiagramRenderer)
  ClassDiagram.prepend(Mermaid::ClassDiagramRenderer)
  FlowchartDiagram.prepend(Mermaid::FlowchartDiagramRenderer)
  PieDiagram.prepend(Mermaid::PieDiagramRenderer)
  GanttDiagram.prepend(Mermaid::GanttDiagramRenderer)
  GitgraphDiagram.prepend(Mermaid::GitgraphDiagramRenderer)
  TimelineDiagram.prepend(Mermaid::TimelineDiagramRenderer) # Add prepend for Timeline
  module Elements
    State.prepend(Mermaid::ElementRenderers::StateRenderer)
    Transition.prepend(Mermaid::ElementRenderers::TransitionRenderer)
    Relationship.prepend(Mermaid::ElementRenderers::RelationshipRenderer)
    Node.prepend(Mermaid::ElementRenderers::NodeRenderer)
    Edge.prepend(Mermaid::ElementRenderers::EdgeRenderer)
    Slice.prepend(Mermaid::ElementRenderers::SliceRenderer)
    Task.prepend(Mermaid::ElementRenderers::TaskRenderer)
    # Add GitCommit, GitBranch, Timeline* prepends if/when renderers are created
  end
end
