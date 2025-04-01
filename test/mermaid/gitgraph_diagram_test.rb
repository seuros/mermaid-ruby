# frozen_string_literal: true

require 'test_helper'

class GitgraphDiagramStringTest < UnitTest
  def test_initial_commit
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'commit1', message: 'Initial commit')

    expected = <<~MERMAID
      gitGraph
        checkout master
        commit id: "commit1"
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_branching
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'c1')
    diagram.branch(name: 'develop')
    diagram.commit(id: 'c2') # On develop branch
    diagram.checkout(name: 'master') # Use master
    diagram.commit(id: 'c3') # On main branch

    expected = <<~MERMAID
      gitGraph
        checkout master
        commit id: "c1"
        branch develop
        checkout develop
        commit id: "c2"
        checkout master
        commit id: "c3"
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_merge
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'c1')
    diagram.branch(name: 'feature')
    diagram.commit(id: 'c2')
    diagram.checkout(name: 'master') # Use master
    diagram.commit(id: 'c3')
    diagram.merge(from_branch_name: 'feature', id: 'm1', tag: 'v1.0') # Merge feature into master

    expected = <<~MERMAID
      gitGraph
        checkout master
        commit id: "c1"
        branch feature
        checkout feature
        commit id: "c2"
        checkout master
        commit id: "c3"
        merge feature id: "m1" tag: "v1.0"
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  def test_commit_with_tag_and_type
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'c1', tag: 'start')
    diagram.commit(id: 'c2', type: :HIGHLIGHT)

    expected = <<~MERMAID
      gitGraph
        checkout master
        commit id: "c1" tag: "start"
        commit id: "c2" type: HIGHLIGHT
    MERMAID
    assert_equal expected.gsub(/\s+/, ' ').strip, diagram.to_mermaid.gsub(/\s+/, ' ').strip
  end

  # Add more tests for complex scenarios if needed
end

# Integration tests might be less critical for gitgraph unless specific rendering issues arise
# class GitgraphDiagramIntegrationTest < IntegrationTest
#   def test_basic_gitgraph_renders
#     diagram = Diagrams::GitgraphDiagram.new
#     diagram.commit(id: 'c1')
#     diagram.branch(name: 'dev')
#     diagram.commit(id: 'c2')
#     mermaid_string = diagram.to_mermaid
#     assert render_mermaid_and_check_errors(mermaid_string), "Basic gitgraph should render"
#   end
# end
