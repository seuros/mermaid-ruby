# frozen_string_literal: true

require_relative '../test_helper'

class TimelineDiagramStringTest < UnitTest
  def test_empty_timeline
    diagram = Diagrams::TimelineDiagram.new(title: 'Empty Timeline')
    expected = <<~MERMAID
      timeline
      title Empty Timeline
    MERMAID

    assert_equal expected.strip, diagram.to_mermaid.strip
  end

  def test_timeline_with_title_and_one_section
    diagram = Diagrams::TimelineDiagram.new(title: 'Project Alpha')
    diagram.add_period(period_label: 'Q1', events: ['Initiation'])
    diagram.add_period(period_label: 'Q2', events: %w[Development Testing])

    result = diagram.to_mermaid

    # Check components
    assert_includes result, 'timeline'
    assert_includes result, 'title Project Alpha'
    assert_includes result, 'Q1 : Initiation'
    assert_includes result, 'Q2 : Development : Testing'

    expected = <<~MERMAID
      timeline
      title Project Alpha
        Q1 : Initiation
        Q2 : Development : Testing
    MERMAID

    assert_equal expected.split.join(' '), result.split.join(' ')
  end

  def test_timeline_with_multiple_sections
    diagram = Diagrams::TimelineDiagram.new(title: 'History')
    diagram.add_section('Ancient Times')
    diagram.add_period(period_label: '1000 BC', events: ['Event A'])
    diagram.add_section('Modern Era')
    diagram.add_period(period_label: '2000 AD', events: ['Event B', 'Event C'])
    diagram.add_period(period_label: '2024 AD', events: ['Event D'])

    result = diagram.to_mermaid

    # Check key components
    assert_includes result, 'timeline'
    assert_includes result, 'title History'
    assert_includes result, 'section Ancient Times'
    assert_includes result, '1000 BC : Event A'
    assert_includes result, 'section Modern Era'
    assert_includes result, '2000 AD : Event B : Event C'
    assert_includes result, '2024 AD : Event D'

    expected = <<~MERMAID
      timeline
      title History
      section Ancient Times
        1000 BC : Event A
      section Modern Era
        2000 AD : Event B : Event C
        2024 AD : Event D
    MERMAID

    assert_equal expected.split.join(' '), result.split.join(' ')
  end

  def test_timeline_no_title
    diagram = Diagrams::TimelineDiagram.new # No title
    diagram.add_period(period_label: 'Phase 1', events: ['Step 1'])
    diagram.add_period(period_label: 'Phase 2', events: ['Step 2'])

    result = diagram.to_mermaid

    # Check components
    assert_includes result, 'timeline'
    refute_includes result, 'title' # No title should be present
    assert_includes result, 'Phase 1 : Step 1'
    assert_includes result, 'Phase 2 : Step 2'

    expected = <<~MERMAID
      timeline
        Phase 1 : Step 1
        Phase 2 : Step 2
    MERMAID

    assert_equal expected.split.join(' '), result.split.join(' ')
  end
end

# Integration tests for timeline might be useful but skipped for now
# class TimelineDiagramIntegrationTest < IntegrationTest
#   def test_simple_timeline_renders
#     diagram = Diagrams::TimelineDiagram.new(title: 'Simple Timeline')
#     diagram.add_period(period_label: 'Event 1 Time', events: 'Event 1 Desc')
#     mermaid_string = diagram.to_mermaid
#     assert render_mermaid_and_check_errors(mermaid_string), "Simple timeline should render"
#   end
# end
