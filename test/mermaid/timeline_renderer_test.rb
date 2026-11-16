# frozen_string_literal: true

require 'test_helper'

class TimelineRendererTest < Minitest::Test
  def test_sections_and_periods
    diagram = Diagrams::TimelineDiagram.new(title: 'Social media')
    diagram.add_period(label: '2002', events: ['LinkedIn'])
    diagram.add_section(title: 'Video')
    diagram.add_period(label: '2005', events: %w[YouTube Vimeo])

    assert_mermaid <<~MERMAID, diagram
      timeline
        title Social media
        2002 : LinkedIn
        section Video
        2005 : YouTube : Vimeo
    MERMAID
  end
end
