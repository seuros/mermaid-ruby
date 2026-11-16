# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::GitgraphDiagram, whose content is already a gitGraph program:
    # each statement renders as the Mermaid statement it models. Names, ids,
    # messages and tags are quoted strings. A main branch other than "main"
    # goes to the front matter config, which Mermaid reads without entity
    # codes, so it must need none.
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

      def body = diagram.statements.map { statement(it) }

      def statement(statement)
        case statement[:command]
        when :commit
          "commit#{option('id', statement[:id])}#{option('msg', statement[:message])}#{tags(statement)}" \
          "#{type(statement[:type])}"
        when :branch then "branch #{quote(statement[:name])}#{" order: #{statement[:order]}" if statement[:order]}"
        when :checkout then "checkout #{quote(statement[:name])}"
        when :merge
          "merge #{quote(statement[:branch])}#{option('id', statement[:id])}#{tags(statement)}" \
          "#{" type: #{statement[:type]}" if statement[:type]}"
        else # :cherry_pick
          "cherry-pick#{option('id', statement[:commit_id])}#{option('parent', statement[:parent])}#{tags(statement)}"
        end
      end

      def option(name, value) = value.nil? ? '' : " #{name}: #{quote(value)}"

      def tags(statement) = statement.fetch(:tags, []).map { option('tag', it) }.join

      # A commit's NORMAL type is Mermaid's default; a merge's explicit type is
      # kept, since leaving it out draws the merge symbol instead.
      def type(type) = type.nil? || type == :NORMAL ? '' : " type: #{type}"
    end
  end
end
