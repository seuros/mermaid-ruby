# frozen_string_literal: true

module Mermaid
  # Turns one diagram into Mermaid text: optional YAML front matter (title,
  # config), the diagram keyword, then the body indented by two spaces.
  # Each subclass renders one diagram class: it names its keyword and lists
  # its body lines.
  class Renderer
    class << self
      def render(diagram)
        renderer = Renderer.registry.fetch(diagram.class) do
          raise TypeError, "no Mermaid renderer for #{diagram.class}"
        end
        renderer.new(diagram).render
      end

      def registry = @registry ||= {}

      private

      def renders(diagram_class, keyword)
        Renderer.registry[diagram_class] = self
        define_method(:keyword) { keyword }
      end
    end

    def initialize(diagram)
      @diagram = diagram
    end

    def render = [*front_matter, keyword, *body.map { "  #{it}" }].join("\n")

    private

    attr_reader :diagram

    # Front matter settings. The title goes here unless the diagram type has
    # its own title statement (see InlineTitle).
    def settings = { title: diagram.title }.compact

    def front_matter
      return [] if settings.empty?

      ['---', *yaml(settings), '---']
    end

    def yaml(hash, indent = '')
      hash.flat_map do |key, value|
        value.is_a?(Hash) ? ["#{indent}#{key}:", *yaml(value, "#{indent}  ")] : ["#{indent}#{key}: #{value.to_json}"]
      end
    end

    # A double-quoted label; Mermaid reads #quot; as a quote inside it.
    def quote(text) = %("#{text.gsub('"', '#quot;')}")
  end
end
