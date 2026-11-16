# frozen_string_literal: true

require 'test_helper'

# Regressions from the 0.1.0 review: each test failed before its fix.
# rake parse checks the same ground against Mermaid's own parser.
class ReviewTest < Minitest::Test
  # 1: ids Mermaid cannot read as names are aliased, the original shown as label.
  def test_state_ids_are_aliased
    diagram = Diagrams::StateDiagram.new
    diagram.add_state(id: 'Mod::Item')
    diagram.add_state(id: 'has space', label: 'Spaced')
    diagram.add_state(id: 's0')
    diagram.add_transition(source_state_id: 'Mod::Item', target_state_id: 'has space')

    assert_mermaid <<~MERMAID, diagram
      stateDiagram-v2
        state "Mod#58;#58;Item" as s1
        state "Spaced" as s2
        s0
        s1 --> s2
    MERMAID
  end

  def test_flowchart_ids_are_aliased
    diagram = Diagrams::FlowchartDiagram.new
    diagram.add_node(id: 'end', label: 'End')
    diagram.add_node(id: 'has space', label: 'Space')
    diagram.add_edge(source_id: 'end', target_id: 'has space')

    assert_mermaid <<~MERMAID, diagram
      flowchart TD
        n0["End"]
        n1["Space"]
        n0 --> n1
    MERMAID
  end

  def test_class_names_are_aliased
    diagram = Diagrams::ClassDiagram.new
    diagram.add_class(name: 'Mod::Item')
    diagram.add_class(name: 'Plain')
    diagram.add_relationship(source_class_name: 'Plain', target_class_name: 'Mod::Item', type: :association)

    assert_mermaid <<~MERMAID, diagram
      classDiagram
        class c0["Mod#58;#58;Item"]
        class Plain
        Plain --> c0
    MERMAID
  end

  def test_entity_names_are_encoded
    diagram = Diagrams::ERDiagram.new
    diagram.add_entity(name: 'a"b', attributes: [{ type: 'varchar(255)', name: 'full name' }])

    assert_mermaid %(erDiagram\n  "a#34;b" {\n    varchar(255) `full name`\n  }), diagram
  end

  def test_branch_names_are_quoted
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'A')
    diagram.branch(name: 'has space')
    diagram.commit(id: 'B')

    assert_mermaid <<~MERMAID, diagram
      gitGraph
        commit id: "A"
        branch "has space"
        commit id: "B"
    MERMAID
  end

  # 2: text stays text: no line breaks, separators or quotes get through raw.
  def test_a_label_cannot_add_statements
    diagram = Diagrams::StateDiagram.new
    diagram.add_state(id: 'a', label: "OK\ninjected --> target")

    assert_mermaid "stateDiagram-v2\n  a : OK#10;injected --#62; target", diagram
  end

  def test_timeline_separators_are_text
    diagram = Diagrams::TimelineDiagram.new
    diagram.add_period(label: 'with : colon', events: ['event : extra'])

    assert_mermaid "timeline\n  with #58; colon : event #58; extra", diagram
  end

  def test_quotes_are_kept
    diagram = Diagrams::ERDiagram.new
    diagram.add_entity(name: 'A')
    diagram.add_relationship(entity1: 'A', entity2: 'A', cardinality1: :ONE_ONLY, cardinality2: :ONE_ONLY,
                             label: 'say "hi"')

    assert_includes diagram.to_mermaid, %("A" ||..|| "A" : "say #34;hi#34;")
  end

  def test_keywords_at_a_line_start_are_text
    diagram = Diagrams::GanttDiagram.new
    diagram.add_task(id: 't', label: 'title case', start: '2026-01-01', duration: '1d')

    assert_mermaid "gantt\n  dateFormat YYYY-MM-DD\n  #116;itle case :t, 2026-01-01, 1d", diagram
  end

  # 3: a cherry-pick renders as Mermaid's cherry-pick of its source. Mermaid
  # names the picked commit itself, so the model refuses picking it again.
  def test_cherry_picks_render_and_a_pick_of_a_pick_is_refused_at_the_call
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'A')
    diagram.branch(name: 'feature')
    diagram.commit(id: 'B')
    diagram.checkout(name: 'main')
    pick = diagram.cherry_pick(commit_id: 'B')
    diagram.checkout(name: 'feature')

    error = assert_raises(ArgumentError) { diagram.cherry_pick(commit_id: pick.id) }
    assert_match(/is a cherry-pick, which Mermaid cannot name/, error.message)
    assert_equal '  cherry-pick id: "B"', diagram.to_mermaid.lines[5].chomp
  end

  # 4: Mermaid rejects a class diagram without statements.
  def test_empty_class_diagram
    assert_mermaid "classDiagram\n  direction TB", Diagrams::ClassDiagram.new
  end

  # 5: values are plain decimals, never exponents.
  def test_pie_values_without_exponent
    diagram = Diagrams::PieDiagram.new
    diagram.add_slice(label: 'small', value: 1e-5)
    diagram.add_slice(label: 'large', value: 1e20)
    diagram.add_slice(label: 'none', value: -0.0)

    assert_mermaid "pie\n  \"small\" : 0.00001\n  \"large\" : 100000000000000000000\n  \"none\" : 0", diagram
  end

  # Values Mermaid cannot carry are refused, not drawn differently.
  def test_refusals
    refusals = {
      /"<<interface>>" as an annotation/ => class_with(attributes: ['<<interface>>']),
      /class member "x \{"/ => class_with(attributes: ['x {']),
      /"\+run\(\)" as an operation/ => class_with(attributes: ['+run()']),
      /"\+go" as an attribute/ => class_with(operations: ['+go']),
      /main branch "a\\"b"/ => Diagrams::GitgraphDiagram.new(main_branch: 'a"b'),
      /title "ﬂ°°1¶ß"/ => Diagrams::FlowchartDiagram.new(title: 'ﬂ°°1¶ß')
    }
    refusals.each do |message, diagram|
      error = assert_raises(ArgumentError, message.inspect) { diagram.to_mermaid }
      assert_match message, error.message
    end
  end

  private

  def class_with(**members) = Diagrams::ClassDiagram.new.tap { it.add_class(name: 'A', **members) }
end
