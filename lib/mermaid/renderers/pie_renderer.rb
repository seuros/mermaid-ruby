# frozen_string_literal: true

module Mermaid
  module Renderers
    # Diagrams::PieDiagram. Values are plain decimals: Mermaid reads no
    # exponent, and Float#to_s writes one for very small or large values.
    class PieRenderer < Renderer
      prepend InlineTitle

      renders Diagrams::PieDiagram, 'pie'

      private

      def body = diagram.slices.map { "#{quote(it.label)} : #{decimal(it.value)}" }

      # The shortest digits that read back as the same Float, without exponent:
      # Float#to_s digits, with the decimal point moved by the exponent.
      def decimal(value)
        return value.to_s if value.is_a?(Integer)

        mantissa, exponent = value.to_s.split('e')
        whole, fraction = mantissa.split('.')
        digits = whole + fraction
        point = whole.size + exponent.to_i
        number = if point <= 0 then "0.#{'0' * -point}#{digits}"
                 elsif point >= digits.size then digits.ljust(point, '0')
                 else "#{digits[0...point]}.#{digits[point..]}"
                 end
        number.include?('.') ? number.sub(/0+\z/, '').delete_suffix('.') : number
      end
    end
  end
end
