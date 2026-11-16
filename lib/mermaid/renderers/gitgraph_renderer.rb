# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::GitgraphDiagram. Mermaid creates a branch at the head of the
    # checked-out branch, so each branch is opened right after its start
    # commit is drawn, which keeps any start commit drawable. Branch names,
    # ids and tags are quoted strings. A main branch other than "main" goes
    # to the front matter config, which Mermaid reads without entity codes,
    # so it must need none.
    #
    # Cherry-picks are refused: Mermaid names a cherry-picked commit itself,
    # so its id would be lost, and a pick of a pick cannot be drawn at all.
    class GitgraphRenderer < Renderer
      renders Diagrams::GitgraphDiagram, 'gitGraph'

      private

      def settings
        return super if diagram.main_branch == 'main'
        if text(diagram.main_branch) != diagram.main_branch
          raise ArgumentError, "Mermaid cannot name the main branch #{diagram.main_branch.inspect}"
        end

        { **super, config: { gitGraph: { mainBranchName: diagram.main_branch } } }
      end

      def body
        branch = diagram.main_branch
        pending = diagram.branches.reject { it.name == diagram.main_branch }
        diagram.commits.flat_map do |commit|
          lines = []
          lines << "checkout #{quote(branch = commit.branch_name)}" unless commit.branch_name == branch
          lines << statement(commit)
          opened, pending = pending.partition { it.start_commit_id == commit.id }
          branch = opened.last.name if opened.any?
          [*lines, *opened.map { "branch #{quote(it.name)}" }]
        end
      end

      def statement(commit)
        case commit.type
        when :MERGE then "merge #{quote(commit.merge_branch_name)}#{options(commit, type: nil)}"
        when :CHERRY_PICK
          raise ArgumentError, "Mermaid cannot draw cherry-pick #{commit.id.inspect}: it names picked commits itself"
        else "commit#{options(commit, type: (commit.type unless commit.type == :NORMAL))}"
        end
      end

      def options(commit, type:)
        [" id: #{quote(commit.id)}", (" tag: #{quote(commit.tag)}" if commit.tag), (" type: #{type}" if type)].join
      end
    end
  end
end
