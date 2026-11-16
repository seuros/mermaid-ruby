# frozen_string_literal: true

require 'test_helper'

class GitgraphRendererTest < Minitest::Test
  def test_every_statement_renders_as_written
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'C1', message: 'init')
    diagram.branch(name: 'develop', order: 1)
    diagram.commit(id: 'D1', type: :HIGHLIGHT)
    diagram.checkout(name: 'main')
    diagram.commit(id: 'C2', tags: %w[v0.1 beta])
    diagram.merge(branch: 'develop', id: 'M1', tags: ['v1'], type: :REVERSE)

    assert_mermaid <<~MERMAID, diagram
      gitGraph
        commit id: "C1" msg: "init"
        branch "develop" order: 1
        commit id: "D1" type: HIGHLIGHT
        checkout "main"
        commit id: "C2" tag: "v0.1" tag: "beta"
        merge "develop" id: "M1" tag: "v1" type: REVERSE
    MERMAID
  end

  def test_cherry_picks_name_their_source
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'A')
    diagram.branch(name: 'feature')
    diagram.commit(id: 'B')
    diagram.checkout(name: 'main')
    diagram.merge(branch: 'feature', id: 'M')
    diagram.checkout(name: 'feature')
    diagram.commit(id: 'C')
    diagram.cherry_pick(commit_id: 'M', parent: 'B', tags: ['ported'])

    assert_mermaid <<~MERMAID, diagram
      gitGraph
        commit id: "A"
        branch "feature"
        commit id: "B"
        checkout "main"
        merge "feature" id: "M"
        checkout "feature"
        commit id: "C"
        cherry-pick id: "M" parent: "B" tag: "ported"
    MERMAID
  end

  def test_generated_ids_are_written_except_for_cherry_picks
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit
    diagram.branch(name: 'other')
    diagram.commit
    diagram.checkout(name: 'main')
    diagram.cherry_pick(commit_id: 'commit-1')

    assert_mermaid <<~MERMAID, diagram
      gitGraph
        commit id: "commit-0"
        branch "other"
        commit id: "commit-1"
        checkout "main"
        cherry-pick id: "commit-1"
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
