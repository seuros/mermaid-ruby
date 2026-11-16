# frozen_string_literal: true

require 'test_helper'

class GitgraphRendererTest < Minitest::Test
  def test_commits_branches_and_merges
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'C1')
    diagram.branch(name: 'develop')
    diagram.commit(id: 'D1', type: :HIGHLIGHT)
    diagram.checkout(name: 'main')
    diagram.commit(id: 'C2', tag: 'v0.1')
    diagram.merge(from_branch_name: 'develop', id: 'M1', tag: 'v1')

    assert_mermaid <<~MERMAID, diagram
      gitGraph
        commit id: "C1"
        branch "develop"
        commit id: "D1" type: HIGHLIGHT
        checkout "main"
        commit id: "C2" tag: "v0.1"
        merge "develop" id: "M1" tag: "v1"
    MERMAID
  end

  def test_a_branch_opens_right_after_its_start_commit
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'C1')
    diagram.commit(id: 'C2')
    diagram.branch(name: 'hotfix', start_commit_id: 'C1')
    diagram.commit(id: 'H1')

    assert_mermaid <<~MERMAID, diagram
      gitGraph
        commit id: "C1"
        branch "hotfix"
        checkout "main"
        commit id: "C2"
        checkout "hotfix"
        commit id: "H1"
    MERMAID
  end

  def test_another_main_branch_goes_to_the_config
    diagram = Diagrams::GitgraphDiagram.new(main_branch: 'trunk', title: 'History')
    diagram.commit(id: 'C1')

    assert_mermaid <<~MERMAID, diagram
      ---
      title: "History"
      config:
        gitGraph:
          mainBranchName: "trunk"
      ---
      gitGraph
        commit id: "C1"
    MERMAID
  end
end
