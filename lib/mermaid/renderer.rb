# frozen_string_literal: true

module Mermaid
  # Turns one diagram into Mermaid text: optional YAML front matter (title,
  # config), the diagram keyword, then the body indented by two spaces.
  # Each subclass renders one diagram class: it names its keyword and lists
  # its body lines.
  #
  # Text from the model never reaches Mermaid's grammars raw. Labels go
  # through #text, ids through #names, and a value Mermaid cannot carry
  # faithfully is refused with ArgumentError rather than drawn differently.
  class Renderer
    # Characters every Mermaid text slot reads as themselves. Anything else
    # becomes a numeric entity (#58;), which Mermaid swaps for a placeholder
    # before lexing and back for the character in the drawn SVG: so no
    # character can end a slot, start a comment or a line, or open markup.
    SAFE = %r{[A-Za-z0-9 _.,!?()\[\]+*/=@$'-]}
    # Mermaid's placeholders for entities; text holding them would be decoded.
    PLACEHOLDERS = /ﬂ°|¶ß/
    # A name Mermaid reads as a plain identifier.
    PLAIN = /\A[A-Za-z][A-Za-z0-9_]*\z/

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

    # YAML is read before entities are, so values go in as JSON strings; only
    # Mermaid's own entity placeholders cannot survive the drawing step.
    def front_matter
      return [] if settings.empty?

      ['---', *yaml(settings), '---']
    end

    def yaml(hash, indent = '')
      hash.flat_map do |key, value|
        next ["#{indent}#{key}:", *yaml(value, "#{indent}  ")] if value.is_a?(Hash)
        raise ArgumentError, "Mermaid cannot show #{key} #{value.inspect}" if value.match?(PLACEHOLDERS)

        ["#{indent}#{key}: #{value.to_json}"]
      end
    end

    # +value+ as text Mermaid shows unchanged. Spaces at either end are
    # encoded too, since grammars trim them.
    def text(value)
      encoded = value.each_char.map { it.match?(SAFE) ? it : "##{it.ord};" }.join
      encoded.sub(/\A +/) { '#32;' * it.size }.sub(/ +\z/) { '#32;' * it.size }
    end

    # Text that starts a line: a first word Mermaid would take for a
    # statement keyword gets its first letter encoded.
    def line_start(value, keywords)
      encoded = text(value)
      return encoded unless keywords.include?(value[/\A\S*/].downcase)

      "##{encoded.ord};#{encoded[1..]}"
    end

    # Mermaid names for model ids, as id => name. A plain identifier that is
    # not reserved names itself; any other id gets the first free
    # "<prefix><n>", and the renderer shows the original as its label.
    def names(ids, prefix, reserved)
      plain = ids.select { it.match?(PLAIN) && !reserved.include?(it.downcase) }.to_set
      count = -1
      ids.to_h do |id|
        next [id, id] if plain.include?(id)

        count += 1
        count += 1 while plain.include?("#{prefix}#{count}")
        [id, "#{prefix}#{count}"]
      end
    end

    def quote(value) = %("#{text(value)}")
  end
end
