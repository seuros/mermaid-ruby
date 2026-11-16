# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::GitgraphDiagram. Mermaid creates a branch at the head of the
    # checked-out branch, so each branch is opened right after its start
    # commit is drawn, which keeps any start commit drawable. A main branch
    # other than "main" goes to the front matter config.
    class GitgraphRenderer < Renderer
      renders Diagrams::GitgraphDiagram, 'gitGraph'

      private

      def settings
        return super if diagram.main_branch == 'main'

        { **super, config: { gitGraph: { mainBranchName: diagram.main_branch } } }
      end

      def body
        branch = diagram.main_branch
        pending = diagram.branches.reject { it.name == diagram.main_branch }
        diagram.commits.flat_map do |commit|
          lines = []
          lines << "checkout #{branch = commit.branch_name}" unless commit.branch_name == branch
          lines << statement(commit)
          opened, pending = pending.partition { it.start_commit_id == commit.id }
          branch = opened.last.name if opened.any?
          [*lines, *opened.map { "branch #{it.name}" }]
        end
      end

      def statement(commit)
        case commit.type
        when :MERGE then "merge #{commit.merge_branch_name}#{options(commit, type: nil)}"
        when :CHERRY_PICK then %(cherry-pick id: "#{commit.cherry_pick_source_id}")
        else "commit#{options(commit, type: (commit.type unless commit.type == :NORMAL))}"
        end
      end

      def options(commit, type:)
        [%( id: "#{commit.id}"), (%( tag: "#{commit.tag}") if commit.tag), (" type: #{type}" if type)].join
      end
    end
  end
end
