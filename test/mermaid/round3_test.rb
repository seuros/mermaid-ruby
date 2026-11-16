# frozen_string_literal: true

require 'test_helper'

# Regressions from the third review: each test failed before its fix.
# rake parse checks the same ground against Mermaid's own evaluation.
class Round3Test < Minitest::Test
  # 2: an explicit merge type is kept; without it Mermaid draws the merge symbol.
  def test_an_explicit_normal_merge_type_is_kept
    diagram = Diagrams::GitgraphDiagram.new
    diagram.commit(id: 'A')
    diagram.branch(name: 'dev')
    diagram.commit(id: 'B', type: :NORMAL)
    diagram.checkout(name: 'main')
    diagram.merge(branch: 'dev', id: 'M', type: :NORMAL)

    assert_equal ['  commit id: "B"', '  merge "dev" id: "M" type: NORMAL'],
                 diagram.to_mermaid.lines.values_at(3, 5).map(&:chomp)
  end

  # 6: Mermaid honours end dates only once the date format is declared.
  def test_gantt_declares_its_date_format
    diagram = Diagrams::GanttDiagram.new
    diagram.add_task(id: 't', label: 'T', start: '2026-01-02', duration: '2026-02-01')

    assert_mermaid "gantt\n  dateFormat YYYY-MM-DD\n  T :t, 2026-01-02, 2026-02-01", diagram
  end
end
