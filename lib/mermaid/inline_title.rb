# frozen_string_literal: true

module Mermaid
  # For diagram types with a `title` statement of their own (pie, gantt,
  # timeline): the title opens the body instead of going to the front matter.
  module InlineTitle
    private

    def settings = super.except(:title)

    def body = [*("title #{text(diagram.title)}" if diagram.title), *super]
  end
end
