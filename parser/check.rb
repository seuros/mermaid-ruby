# frozen_string_literal: true

# rake parse: renders a battery of diagrams, parses each with Mermaid's own
# parser (parser/parse.mjs, Node) and checks that Mermaid read back the model
# that was rendered: names, labels, ids, links and values, not just syntax.
# A case either renders and round-trips, or must be refused with
# ArgumentError when it is marked so.
require 'json'
require 'open3'
require 'tmpdir'
require 'mermaid'

module ParserCheck
  # Text Mermaid must carry unchanged in every name, id and label slot.
  HOSTILE = [
    'plain', 'has space', 'Mod::Item', '日本語', 'é', 'a"b', "it's", 'back`tick', 'a,b', 'semi; colon',
    'with : colon', 'pipe | bar', 'brackets [x] {y} (z)', '<b>bold</b>', 'a & b', 'literal #quot;', '#35;',
    '50%% off', '%%comment', "line\nbreak", "x\ninjected --> target", "tab\there", "cr\rhere", ' padded ',
    'trailing ', '-->', '--', '[*]', '*x', 'ﬂ°°35¶ß', '\\backslash', '~tilde~', '$dollar', 'a.b', 'a-b',
    '1st', 'end', 'graph', 'flowchart', 'subgraph', 'style', 'classDef', 'class', 'click', 'call', 'direction',
    'state', 'note', 'as', 'root_start', 'root_end', 'title', 'section', 'commit', 'merge', 'branch',
    'checkout', 'cherry-pick', 'main', 'dateFormat', 'excludes', 'accTitle', 'o', 'x', 'default'
  ].freeze

  TYPES = %i[NORMAL REVERSE HIGHLIGHT MERGE CHERRY_PICK].freeze
  CARDINALITY = { ZERO_OR_ONE: 'ZERO_OR_ONE', ONE_ONLY: 'ONLY_ONE', ZERO_OR_MORE: 'ZERO_OR_MORE',
                  ONE_OR_MORE: 'ONE_OR_MORE' }.freeze

  Case = Data.define(:name, :diagram, :refuse)

  module_function

  def cases
    [*empty_cases, *HOSTILE.each_with_index.flat_map { |text, index| hostile_cases(text, index) },
     *number_cases, *member_cases, *gantt_data_cases, *git_cases]
  end

  def empty_cases
    Diagrams::Base.subclasses.map { Case.new("empty #{it.type}", it.new, false) }
  end

  def hostile_cases(text, index)
    tag = "#{index} #{text.inspect}"
    # Front matter titles are not entity-coded, so Mermaid's placeholders in
    # them are refused; pie, gantt and timeline titles are in the body.
    title = text.match?(Mermaid::Renderer::PLACEHOLDERS)
    [
      Case.new("flowchart #{tag}", flowchart(text), title),
      *(Case.new("state #{tag}", state(text), title) unless text == '*'),
      Case.new("class #{tag}", class_diagram(text), title),
      Case.new("er #{tag}", er(text), title),
      Case.new("pie #{tag}", pie(text), false),
      Case.new("gantt #{tag}", gantt(text), false),
      Case.new("timeline #{tag}", timeline(text), false),
      *(Case.new("git #{tag}", git(text), title) unless text == 'main')
    ]
  end

  def flowchart(text)
    Diagrams::FlowchartDiagram.new(title: text).tap do |d|
      d.add_node(id: text, label: text)
      d.add_node(id: 'target', label: 'Target')
      d.add_edge(source_id: text, target_id: 'target', label: text)
      d.add_edge(source_id: 'target', target_id: text)
    end
  end

  def state(text)
    Diagrams::StateDiagram.new(title: text).tap do |d|
      d.add_state(id: text)
      d.add_state(id: "#{text}2", label: text)
      d.add_state(id: 'target')
      d.add_transition(source_state_id: '*', target_state_id: text)
      d.add_transition(source_state_id: text, target_state_id: 'target', label: text, guard: text, action: text)
      d.add_transition(source_state_id: "#{text}2", target_state_id: '*')
    end
  end

  def class_diagram(text)
    Diagrams::ClassDiagram.new(title: text).tap do |d|
      d.add_class(name: text, attributes: ['+String name'], operations: ['+save() bool'])
      d.add_class(name: 'Target')
      d.add_relationship(source_class_name: text, target_class_name: 'Target', type: :association, label: text)
      d.add_relationship(source_class_name: 'Target', target_class_name: text, type: :inheritance)
    end
  end

  def er(text)
    Diagrams::ERDiagram.new(title: text).tap do |d|
      d.add_entity(name: text, attributes: [{ type: text, name: text, keys: %i[PK FK UK], comment: text },
                                            { type: 'int', name: 'id' }])
      d.add_entity(name: 'Target')
      d.add_relationship(entity1: text, entity2: 'Target', cardinality1: :ONE_ONLY, cardinality2: :ZERO_OR_MORE,
                         label: text)
      d.add_relationship(entity1: 'Target', entity2: text, cardinality1: :ZERO_OR_ONE, cardinality2: :ONE_OR_MORE,
                         identifying: true)
    end
  end

  def pie(text)
    Diagrams::PieDiagram.new(title: text).tap do |d|
      d.add_slice(label: text, value: 1)
      d.add_slice(label: 'other', value: 2.5)
    end
  end

  def gantt(text)
    Diagrams::GanttDiagram.new(title: text).tap do |d|
      d.add_task(id: 'first', label: text, start: '2026-01-01', duration: '1d', status: :done)
      d.add_section(title: text)
      d.add_task(id: 'second', label: text, start: 'after first', duration: '2d')
    end
  end

  def timeline(text)
    Diagrams::TimelineDiagram.new(title: text).tap do |d|
      d.add_period(label: text, events: [text])
      d.add_section(title: text)
      d.add_period(label: "#{text}2", events: [text, 'event'])
    end
  end

  def git(text)
    Diagrams::GitgraphDiagram.new(title: text).tap do |d|
      d.commit(id: text, tag: text)
      d.branch(name: text)
      d.commit(id: "#{text}2")
      d.checkout(name: 'main')
      d.commit(id: "#{text}3", type: :REVERSE)
      d.merge(from_branch_name: text, id: "#{text}4", tag: text)
    end
  end

  def number_cases
    [0, 1, 1.5, 1e-5, 1.0e-300, 1e20, 1e300, 123_456_789.123, 0.1 + 0.2, 10**30, Float::MAX].map do |value|
      Case.new("pie value #{value}", Diagrams::PieDiagram.new.tap { it.add_slice(label: 'x', value:) }, false)
    end
  end

  def member_cases
    {
      ['+String name'] => false, ['-List~int~ ids'] => false, ['$count int'] => false,
      ['broken {'] => true, ['two\nlines'.gsub('\n', "\n")] => true, ['+run()'] => true
    }.map.with_index do |(attributes, refuse), index|
      diagram = Diagrams::ClassDiagram.new.tap { it.add_class(name: 'A', attributes:, operations: ['+go() int']) }
      Case.new("class members #{index}", diagram, refuse)
    end + [Case.new('class operation without parens',
                    Diagrams::ClassDiagram.new.tap { it.add_class(name: 'A', operations: ['+go']) }, true)]
  end

  def gantt_data_cases
    {
      { id: 'has space' } => true, { id: 'a,b' } => true, { start: '2026-01-01, x' } => true,
      { duration: "1d\nx" } => true, { start: '2026-01-01 10:00' } => false, { id: 'task-1_b' } => false
    }.map.with_index do |(override, refuse), index|
      task = { id: 't', label: 'T', start: '2026-01-01', duration: '1d', **override }
      Case.new("gantt data #{index}", Diagrams::GanttDiagram.new.tap { it.add_task(**task) }, refuse)
    end
  end

  def git_cases
    [
      Case.new('git cherry-pick', git_history { it.cherry_pick(commit_id: 'B', id: 'pick') }, true),
      Case.new('git branch from an old commit', git_history { it.branch(name: 'old', start_commit_id: 'A') }, false),
      Case.new('git two branches at one commit', git_history { it.branch(name: 'second', start_commit_id: 'B') },
               false),
      Case.new('git main branch name', git_main('trunk'), false),
      Case.new('git main branch with space', git_main('main line'), false),
      Case.new('git main branch with quote', git_main('a"b'), true)
    ]
  end

  def git_history
    Diagrams::GitgraphDiagram.new.tap do |d|
      d.commit(id: 'A')
      d.branch(name: 'feature')
      d.commit(id: 'B')
      d.checkout(name: 'main')
      d.commit(id: 'C')
      yield d
    end
  end

  def git_main(name)
    Diagrams::GitgraphDiagram.new(main_branch: name).tap do |d|
      d.commit(id: 'A')
      d.branch(name: 'dev')
      d.commit(id: 'B')
      d.checkout(name:)
      d.merge(from_branch_name: 'dev')
    end
  end

  # What Mermaid must read back, in the shape parser/parse.mjs reports.
  def expected(diagram)
    facts = case diagram
            when Diagrams::FlowchartDiagram then flowchart_facts(diagram)
            when Diagrams::StateDiagram then state_facts(diagram)
            when Diagrams::ClassDiagram then class_facts(diagram)
            when Diagrams::ERDiagram then er_facts(diagram)
            when Diagrams::PieDiagram then { 'slices' => diagram.slices.map { [it.label, it.value.to_f] } }
            when Diagrams::GanttDiagram then gantt_facts(diagram)
            when Diagrams::TimelineDiagram then timeline_facts(diagram)
            when Diagrams::GitgraphDiagram then git_facts(diagram)
            end
    facts.merge('title' => diagram.title)
  end

  def flowchart_facts(diagram)
    labels = diagram.nodes.to_h { [it.id, it.label] }
    { 'nodes' => diagram.nodes.map(&:label),
      'edges' => diagram.edges.map { [labels[it.source_id], labels[it.target_id], it.label.to_s] } }
  end

  def state_facts(diagram)
    names = diagram.states.to_h { [it.id, it.label || it.id] }.merge('*' => '*')
    { 'states' => diagram.states.map { it.label || it.id },
      'transitions' => diagram.transitions.map do |t|
        text = [t.label, ("[#{t.guard}]" if t.guard), ("/ #{t.action}" if t.action)].compact.join(' ')
        [names[t.source_state_id], names[t.target_state_id], text]
      end }
  end

  def class_facts(diagram)
    classes = diagram.classes.map do |entity|
      [entity.name, entity.attributes.map { member_display(it) }, entity.operations.map { method_display(it) }]
    end
    { 'classes' => classes,
      'relationships' => diagram.relationships.map { [it.source_class_name, it.target_class_name, it.label.to_s] } }
  end

  # Member strings are Mermaid notation: it shows ~T~ generics as <T> (held
  # HTML-escaped) and a method's return type after " : ".
  def member_display(member) = member.gsub(/~([^~]*)~/, '&lt;\1&gt;')

  def method_display(operation) = member_display(operation).sub(/\)\s+(?=\S)/, ') : ')

  def er_facts(diagram)
    { 'entities' => diagram.entities.map do |e|
      [e.name, e.attributes.map { [it.type, it.name, it.keys.map(&:to_s), it.comment.to_s] }]
    end,
      'relationships' => diagram.relationships.map do |r|
        [r.entity1, r.entity2, r.label.to_s, CARDINALITY[r.cardinality1], CARDINALITY[r.cardinality2],
         r.identifying ? 'IDENTIFYING' : 'NON_IDENTIFYING']
      end }
  end

  def gantt_facts(diagram)
    { 'sections' => diagram.sections.filter_map(&:title),
      'tasks' => diagram.sections.flat_map do |section|
        section.tasks.map { [section.title.to_s, it.label, it.id, it.status&.to_s, it.start, it.duration] }
      end }
  end

  def timeline_facts(diagram)
    { 'sections' => diagram.sections.filter_map(&:title),
      'periods' => diagram.sections.flat_map do |section|
        section.periods.map { [section.title.to_s, it.label, it.events] }
      end }
  end

  def git_facts(diagram)
    # Mermaid's graph always has its main branch, even before a commit.
    { 'branches' => (diagram.branches.map(&:name) | [diagram.main_branch]).sort, 'mainBranch' => diagram.main_branch,
      'commits' => diagram.commits.map do |c|
        [c.id, c.branch_name, c.parent_ids, [c.tag].compact, TYPES.index(c.type)]
      end }
  end

  def normalize(facts)
    facts = facts.transform_keys(&:to_s)
    facts['branches'] = facts['branches'].sort if facts['branches']
    facts['slices'] = facts['slices'].map { |label, value| [label, value.to_f] } if facts['slices']
    facts
  end

  def run
    cases = self.cases
    rendered, problems = render(cases)
    results = parse(rendered.map { |c, text| { name: c.name, text: } })
    rendered.zip(results).each do |(c, text), result|
      unless result['facts']
        state = result['parsed'] ? 'parsed, but unreadable' : 'not parsed'
        problems << "#{c.name}: #{state}: #{result['error']}\n#{text}"
        next
      end

      actual = normalize(result['facts'])
      want = normalize(expected(c.diagram))
      problems << "#{c.name}: read back differently\n#{text}\n#{diff(want, actual)}" unless want == actual
    end
    puts "#{cases.size} cases: #{rendered.size} parsed by Mermaid, #{cases.size - rendered.size} refused as expected"
    abort problems.join("\n\n") if problems.any?
  end

  def render(cases)
    problems = []
    rendered = cases.filter_map do |c|
      text = c.diagram.to_mermaid
      problems << "#{c.name}: rendered, but must be refused" if c.refuse
      [c, text] unless c.refuse
    rescue ArgumentError => e
      problems << "#{c.name}: refused: #{e.message}" unless c.refuse
      nil
    end
    [rendered, problems]
  end

  def parse(cases)
    Dir.mktmpdir do |dir|
      input = File.join(dir, 'cases.json')
      output = File.join(dir, 'results.json')
      File.write(input, JSON.generate(cases))
      out, status = Open3.capture2e('node', File.join(__dir__, 'parse.mjs'), input, output)
      abort "parse.mjs failed:\n#{out}" unless status.success?
      JSON.parse(File.read(output))
    end
  end

  def diff(want, actual)
    (want.keys | actual.keys).filter_map do |key|
      if want[key] != actual[key]
        "  #{key}: expected #{want[key].inspect}\n  #{' ' * key.size}  got      #{actual[key].inspect}"
      end
    end.join("\n")
  end
end

ParserCheck.run if $PROGRAM_NAME == __FILE__
