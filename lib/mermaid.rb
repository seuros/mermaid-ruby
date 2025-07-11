# frozen_string_literal: true

require_relative 'mermaid/version'
require 'diagrams'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'er_diagram_renderer' => 'ERDiagramRenderer',
  'erd_entity_renderer' => 'ERDEntityRenderer',
  'erd_relationship_renderer' => 'ERDRelationshipRenderer'
)
loader.setup
loader.eager_load

module Diagrams
  StateDiagram.prepend(Mermaid::StateDiagramRenderer)
  ClassDiagram.prepend(Mermaid::ClassDiagramRenderer)
  FlowchartDiagram.prepend(Mermaid::FlowchartDiagramRenderer)
  PieDiagram.prepend(Mermaid::PieDiagramRenderer)
  GanttDiagram.prepend(Mermaid::GanttDiagramRenderer)
  GitgraphDiagram.prepend(Mermaid::GitgraphDiagramRenderer)
  TimelineDiagram.prepend(Mermaid::TimelineDiagramRenderer)
  ERDiagram.prepend(Mermaid::ERDiagramRenderer)
  module Elements
    State.prepend(Mermaid::ElementRenderers::StateRenderer)
    Transition.prepend(Mermaid::ElementRenderers::TransitionRenderer)
    Relationship.prepend(Mermaid::ElementRenderers::RelationshipRenderer)
    Node.prepend(Mermaid::ElementRenderers::NodeRenderer)
    Edge.prepend(Mermaid::ElementRenderers::EdgeRenderer)
    Slice.prepend(Mermaid::ElementRenderers::SliceRenderer)
    Task.prepend(Mermaid::ElementRenderers::TaskRenderer)
    ERDEntity.prepend(Mermaid::ElementRenderers::ERDEntityRenderer) # Prepend ERD element renderers
    ERDRelationship.prepend(Mermaid::ElementRenderers::ERDRelationshipRenderer)
  end
end
