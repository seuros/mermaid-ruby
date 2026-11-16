# frozen_string_literal: true

# rake parse: renders a battery of diagrams, parses each with Mermaid's own
# parser (parser/parse.mjs, Node) and checks that Mermaid read back the model
# that was rendered: which node is which, labels, links and their kind,
# values and commits, not just syntax. Every case must also round-trip
# through to_json/from_json. A case either renders and matches, or must be
# refused (by the model or the renderer) when it is marked so. Negative
# controls mutate rendered output; each mutant must be rejected, or the
# check is too weak to trust.
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
    'checkout', 'cherry-pick', 'main', 'dateFormat', 'excludes', 'accTitle', 'o', 'x', 'default',
    "x\0y", 'emoji😀', 'style:#;', 'classDef:#;', '__proto__', 'constructor', 'hasOwnProperty', 'toString',
    'valueOf', 'prototype'
  ].freeze

  # Mermaid's gitGraph commit types and class relations, from its docs.
  COMMIT_TYPES = %i[NORMAL REVERSE HIGHLIGHT MERGE CHERRY_PICK].freeze
  AGGREGATION = 0
  EXTENSION = 1
  COMPOSITION = 2
  DEPENDENCY = 3
  LINE = 0
  DOTTED = 1
  RELATIONS = {
    inheritance: [EXTENSION, 'none', LINE], composition: [COMPOSITION, 'none', LINE],
    aggregation: [AGGREGATION, 'none', LINE], association: ['none', DEPENDENCY, LINE],
    dependency: ['none', DEPENDENCY, DOTTED], realization: [EXTENSION, 'none', DOTTED],
    link: %w[none none].push(LINE)
  }.freeze
  CARDINALITY = { ZERO_OR_ONE: 'ZERO_OR_ONE', ONE_ONLY: 'ONLY_ONE', ZERO_OR_MORE: 'ZERO_OR_MORE',
                  ONE_OR_MORE: 'ONE_OR_MORE' }.freeze

  # +diagram+ is the built diagram, or the error the model refused it with.
  Case = Data.define(:name, :diagram, :refuse)

  module_function

  def build(name, refuse: false)
    Case.new(name, yield, refuse)
  rescue ArgumentError, RangeError => e
    Case.new(name, e, refuse)
  end

  def cases
    [*empty_cases, *HOSTILE.each_with_index.flat_map { |text, index| hostile_cases(text, index) },
     *identity_cases, *number_cases, *member_cases, *gantt_cases, *gantt_schedule_cases, *git_cases,
     *random_git_cases]
  end

  def empty_cases = Diagrams::Base.subclasses.map { |type| build("empty #{type.type}") { type.new } }

  def hostile_cases(text, index)
    tag = "#{index} #{text.inspect}"
    # Front matter titles are not entity-coded, so Mermaid's placeholders in
    # them are refused; pie, gantt and timeline titles are in the body.
    title = text.match?(Mermaid::Renderer::PLACEHOLDERS)
    [
      build("flowchart #{tag}", refuse: title) { flowchart(text) },
      *(build("state #{tag}", refuse: title) { state(text) } unless text == '*'),
      build("class #{tag}", refuse: title) { class_diagram(text) },
      build("er #{tag}", refuse: title) { er(text) },
      build("pie #{tag}") { pie(text) },
      build("gantt #{tag}") { gantt(text) },
      build("timeline #{tag}") { timeline(text) },
      *(build("git #{tag}", refuse: title) { git(text) } unless %w[main picker].include?(text))
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
      Diagrams::Elements::Relationship::TYPES.each_with_index do |type, i|
        source, target = i.even? ? [text, 'Target'] : ['Target', text]
        d.add_relationship(source_class_name: source, target_class_name: target, type:, label: (text if i.zero?))
      end
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
      d.commit(id: text, tags: [text, "#{text}2"], message: text)
      d.branch(name: text, order: 2)
      d.commit(id: "#{text}2")
      d.checkout(name: 'main')
      d.commit(id: "#{text}3", type: :REVERSE)
      d.merge(branch: text, id: "#{text}4", tags: [text], type: :HIGHLIGHT)
      d.branch(name: 'picker')
      d.cherry_pick(commit_id: "#{text}2", tags: [text])
    end
  end

  def identity_cases
    [
      build('identity flowchart') do
        Diagrams::FlowchartDiagram.new.tap do |d|
          d.add_node(id: 'a', label: 'Same')
          d.add_node(id: 'b', label: 'Same')
          d.add_node(id: 'c', label: 'Goal')
          d.add_edge(source_id: 'a', target_id: 'c')
        end
      end,
      build('identity state') do
        Diagrams::StateDiagram.new.tap do |d|
          d.add_state(id: 'a', label: 'Same')
          d.add_state(id: 'b', label: 'Same')
          d.add_transition(source_state_id: 'a', target_state_id: 'b')
        end
      end
    ]
  end

  def number_cases
    values = [0, 1, 1.5, 1e-5, 1.0e-300, 1e20, 1e300, 123_456_789.123, 0.1 + 0.2, 2**53, Float::MAX, -0.0,
              Float::MIN, Float::MIN * Float::EPSILON]
    [*values.map { |value| build("pie value #{value}") { pie_of(value) } },
     *[(2**53) + 1, 10**400].map { |value| build("pie value #{value.to_s[0, 20]}", refuse: true) { pie_of(value) } }]
  end

  def pie_of(value) = Diagrams::PieDiagram.new.tap { it.add_slice(label: 'x', value:) }

  def member_cases
    {
      ['+String name'] => false, ['-List~int~ ids'] => false, ['$count int'] => false,
      ['broken {'] => true, ["two\nlines"] => true, ['+run()'] => true, ['<<interface>>'] => true
    }.map.with_index do |(attributes, refuse), index|
      build("class members #{index}", refuse:) do
        Diagrams::ClassDiagram.new.tap { it.add_class(name: 'A', attributes:, operations: ['+go() int']) }
      end
    end + [build('class operation without parens', refuse: true) do
      Diagrams::ClassDiagram.new.tap { it.add_class(name: 'A', operations: ['+go']) }
    end]
  end

  def gantt_cases
    refused = [*%w[done active crit milestone vert].map { { id: it } }, { id: 'has space' }, { id: 'a,b' },
               { start: 'not-a-date' }, { start: ' 2026-01-01' }, { start: '2026-02-30' }, { start: 'active' },
               { start: 'after nope' }, { duration: 'bad' }, { duration: '1d ' }, { duration: '1d:2d' },
               { duration: "1d\nx" }, { start: '1500-02-29' }, { id: '__proto__' }, { id: 'constructor' },
               { start: 'after toString' }, { duration: '999999999999999d' }, { duration: "#{'9' * 400}d" },
               { duration: '8000y' }, { start: '9999-12-31', duration: '1d' }]
    accepted = [{ id: 'task-1_b' }, { start: 'after first' }, { duration: 'until first' },
                { duration: '2026-02-01' }, { duration: '1.5h' }, { duration: '250ms' }, { duration: '3M' },
                { start: '1582-10-10' }, { start: '0000-01-01' }, { start: '2024-02-29', duration: '1y' },
                { duration: '0.5d' }, { duration: '2.5d' }, { duration: '1.25h' }, { duration: '0.0001ms' },
                { duration: '13M' }, { start: 'after first', duration: '3w' }, { duration: '0000000000000001d' }]
    [*refused.map { |task| [task, true] }, *accepted.map { |task| [task, false] }].map.with_index do |(task, refuse), i|
      build("gantt task #{i} #{task.inspect}", refuse:) do
        Diagrams::GanttDiagram.new.tap do |d|
          d.add_task(id: 'first', label: 'First', start: '2026-01-01', duration: '1d')
          d.add_task(id: 't', label: 'T', start: '2026-01-02', duration: '1d', **task)
        end
      end
    end
  end

  # Named, so the negative controls can find them.
  def gantt_schedule_cases
    [
      build('gantt month clamp') do
        Diagrams::GanttDiagram.new.tap { it.add_task(id: 'a', label: 'A', start: '2026-01-31', duration: '1M') }
      end,
      build('gantt day rounding') do
        Diagrams::GanttDiagram.new.tap do |d|
          d.add_task(id: 'a', label: 'A', start: '2026-03-01', duration: '1.5d')
          d.add_task(id: 'b', label: 'B', start: 'after a', duration: 'until a')
        end
      end
    ]
  end

  def git_cases
    [
      build('git pick') { git_history { it.cherry_pick(commit_id: 'B') } },
      build('git pick with tags') { git_history { it.cherry_pick(commit_id: 'B', tags: %w[ported v2]) } },
      build('git pick of a merge') do
        git_history do |d|
          d.merge(branch: 'feature', id: 'M')
          d.checkout(name: 'feature')
          d.commit(id: 'D')
          d.cherry_pick(commit_id: 'M', parent: 'C')
        end
      end,
      build('git branch before a commit') do
        Diagrams::GitgraphDiagram.new.tap do |d|
          d.branch(name: 'early', order: 1)
          d.commit(id: 'E')
          d.checkout(name: 'main')
          d.commit(id: 'A')
          d.merge(branch: 'early')
        end
      end,
      build('git merge with a normal type') { git_history { it.merge(branch: 'feature', id: 'M', type: :NORMAL) } },
      build('git lane order at 2**53') do
        Diagrams::GitgraphDiagram.new.tap do |d|
          d.commit(id: 'A')
          d.branch(name: 'high', order: 2**53)
          d.branch(name: 'low', order: (2**53) - 1)
        end
      end,
      build('git lane order past 2**53', refuse: true) do
        Diagrams::GitgraphDiagram.new.tap { |d| d.branch(name: 'x', order: (2**53) + 1) }
      end,
      build('git main branch name') { git_main('trunk') },
      build('git main branch with space') { git_main('main line') },
      build('git main branch with quote', refuse: true) { git_main('a"b') }
    ]
  end

  def git_history
    Diagrams::GitgraphDiagram.new.tap do |d|
      d.commit(id: 'A', message: 'start')
      d.branch(name: 'feature')
      d.commit(id: 'B', tags: ['wip'])
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
      d.merge(branch: 'dev')
    end
  end

  # Histories built by random statements: whatever the model accepts,
  # Mermaid must accept and read back the same.
  def random_git_cases
    random = Random.new(53)
    Array.new(40) do |index|
      build("git random #{index}") do
        Diagrams::GitgraphDiagram.new.tap { |d| 40.times { |step| random_statement(d, random, step) } }
      end
    end
  end

  def random_statement(diagram, random, step)
    case random.rand(6)
    when 0
      diagram.commit(id: ("c#{step}" unless random.rand(3).zero?), tags: random.rand(4).zero? ? ["t#{step}"] : [],
                     type: %i[NORMAL REVERSE HIGHLIGHT].sample(random:), message: "m#{step}")
    when 1 then diagram.branch(name: "b#{step}", order: random.rand(3).zero? ? random.rand(4) : nil)
    when 2 then diagram.checkout(name: diagram.branches.sample(random:).name)
    when 3 then diagram.merge(branch: diagram.branches.sample(random:).name, type: [nil, :REVERSE].sample(random:))
    else
      source = diagram.commits.sample(random:) or return
      diagram.cherry_pick(commit_id: source.id, parent: (source.parents.sample(random:) if random.rand(2).zero?))
    end
  rescue ArgumentError
    nil # Refused like Mermaid; the history goes on.
  end

  # What Mermaid must read back, in the shape #actual brings Mermaid's facts to.
  def expected(diagram)
    facts = case diagram
            when Diagrams::FlowchartDiagram then flowchart_facts(diagram)
            when Diagrams::StateDiagram then state_facts(diagram)
            when Diagrams::ClassDiagram then class_facts(diagram)
            when Diagrams::ERDiagram then er_facts(diagram)
            when Diagrams::PieDiagram then { 'slices' => diagram.slices.map { [it.label, it.value] } }
            when Diagrams::GanttDiagram then gantt_facts(diagram)
            when Diagrams::TimelineDiagram then timeline_facts(diagram)
            when Diagrams::GitgraphDiagram then git_facts(diagram)
            end
    facts.merge('title' => diagram.title)
  end

  def flowchart_facts(diagram)
    index = diagram.nodes.each_with_index.to_h { |node, i| [node.id, i] }
    { 'nodes' => diagram.nodes.map(&:label),
      'edges' => diagram.edges.map { [index[it.source_id], index[it.target_id], it.label.to_s] } }
  end

  def state_facts(diagram)
    index = diagram.states.each_with_index.to_h { |state, i| [state.id, i] }.merge('*' => '*')
    { 'states' => diagram.states.map { it.label || it.id },
      'transitions' => diagram.transitions.map do |t|
        text = [t.label, ("[#{t.guard}]" if t.guard), ("/ #{t.action}" if t.action)].compact.join(' ')
        [index[t.source_state_id], index[t.target_state_id], text]
      end }
  end

  def class_facts(diagram)
    index = diagram.classes.each_with_index.to_h { |entity, i| [entity.name, i] }
    classes = diagram.classes.map do |entity|
      [entity.name, entity.attributes.map { member_display(it) }, entity.operations.map { method_display(it) }]
    end
    { 'classes' => classes,
      'relationships' => diagram.relationships.map do |r|
        [index[r.source_class_name], index[r.target_class_name], r.label.to_s, *RELATIONS.fetch(r.type)]
      end }
  end

  # Member strings are Mermaid notation: it shows ~T~ generics as <T> (held
  # HTML-escaped) and a method's return type after " : ".
  def member_display(member) = member.gsub(/~([^~]*)~/, '&lt;\1&gt;')

  def method_display(operation) = member_display(operation).sub(/\)\s+(?=\S)/, ') : ')

  def er_facts(diagram)
    index = diagram.entities.each_with_index.to_h { |entity, i| [entity.name, i] }
    { 'entities' => diagram.entities.map do |e|
      [e.name, e.attributes.map { [it.type, it.name, it.keys.map(&:to_s), it.comment.to_s] }]
    end,
      'relationships' => diagram.relationships.map do |r|
        [index[r.entity1], index[r.entity2], r.label.to_s, CARDINALITY[r.cardinality1], CARDINALITY[r.cardinality2],
         r.identifying ? 'IDENTIFYING' : 'NON_IDENTIFYING']
      end }
  end

  # Each task's start and end as Mermaid evaluates them, in UTC milliseconds.
  def gantt_facts(diagram)
    times = diagram.schedule.transform_values { |range| [range.begin, range.end].map { (it.to_r * 1000).to_i } }
    { 'sections' => diagram.sections.filter_map(&:title),
      'tasks' => diagram.sections.flat_map do |section|
        section.tasks.map { [section.title.to_s, it.label, it.id, it.status&.to_s, *times.fetch(it.id)] }
      end }
  end

  def timeline_facts(diagram)
    { 'sections' => diagram.sections.filter_map(&:title),
      'periods' => diagram.sections.flat_map do |section|
        section.periods.map { [section.title.to_s, it.label, it.events] }
      end }
  end

  # Commits by position; a cherry-pick's id is Mermaid's to choose.
  def git_facts(diagram)
    index = diagram.commits.each_with_index.to_h { |commit, i| [commit.id, i] }
    lanes = diagram.branches.each_with_index.sort_by { |branch, i| [branch.order || 0, i] }.map { it.first.name }
    { 'lanes' => lanes, 'mainBranch' => diagram.main_branch,
      'commits' => diagram.commits.map do |c|
        [(c.id unless c.type == :CHERRY_PICK), c.branch, c.parents.map { index[it] }, c.tags,
         COMMIT_TYPES.index(c.type), c.custom_type && COMMIT_TYPES.index(c.custom_type), c.message.to_s]
      end }
  end

  # Mermaid's facts with its ids replaced by positions, as #expected has them.
  def actual(facts)
    facts = facts.dup
    position = ->(list) { list.each_with_index.to_h { |item, i| [item.first, i] } }
    if facts['nodes']
      at = position[facts['nodes']]
      facts['nodes'] = facts['nodes'].map(&:last)
      facts['edges'] = facts['edges'].map { |from, to, label| [at[from], at[to], label] }
    elsif facts['states']
      at = position[facts['states']].merge('*' => '*')
      facts['states'] = facts['states'].map(&:last)
      facts['transitions'] = facts['transitions'].map { |from, to, label| [at[from], at[to], label] }
    elsif facts['classes']
      at = position[facts['classes']]
      facts['classes'] = facts['classes'].map { it.drop(1) }
      facts['relationships'] = facts['relationships'].map { |from, to, *rest| [at[from], at[to], *rest] }
    elsif facts['entities']
      at = position[facts['entities']]
      facts['entities'] = facts['entities'].map { it.drop(1) }
      facts['relationships'] = facts['relationships'].map { |from, to, *rest| [at[from], at[to], *rest] }
    elsif facts['commits']
      at = facts['commits'].each_with_index.to_h { |commit, i| [commit.first, i] }
      facts['commits'] = facts['commits'].map do |id, branch, parents, tags, type, custom, message|
        [(id unless type == COMMIT_TYPES.index(:CHERRY_PICK)), branch, parents.map { at[it] }, tags, type, custom,
         message]
      end
    end
    facts
  end

  # Rendered output, altered so that it still parses but means something
  # else: the check must reject every one.
  MUTANTS = {
    'identity flowchart' => ->(text) { text.sub('  a --> c', '  b --> c') },
    'identity state' => ->(text) { text.sub('  a --> b', '  b --> a') },
    'class 0 "plain"' => ->(text) { text.sub('<|--', '-->') },
    'class 1 "has space"' => ->(text) { text.sub('-->', '..>') },
    'er 0 "plain"' => ->(text) { text.sub('||..o{', '||--o{') },
    'state 0 "plain"' => ->(text) { text.sub('[*] --> plain', 'plain --> [*]') },
    'flowchart 0 "plain"' => ->(text) { text.sub('target["Target"]', 'target["Targer"]') },
    'pie value 1.5' => ->(text) { text.sub('1.5', '1.4') },
    'gantt 0 "plain"' => ->(text) { text.sub(':done, first', ':crit, first') },
    'timeline 0 "plain"' => ->(text) { text.sub('plain2 : plain : event', 'plain2 : event : plain') },
    'git 0 "plain"' => ->(text) { text.sub('type: REVERSE', 'type: HIGHLIGHT') },
    'git pick with tags' => ->(text) { text.sub(' tag: "v2"', '') },
    'git pick of a merge' => ->(text) { text.sub('parent: "C"', 'parent: "B"') },
    'git 1 "has space"' => ->(text) { text.sub(' order: 2', '') },
    'git merge with a normal type' => ->(text) { text.sub(' type: NORMAL', '') },
    'gantt month clamp' => ->(text) { text.sub('2026-01-31', '2026-01-30') },
    'gantt day rounding' => ->(text) { text.sub('1.5d', '1d') },
    'git lane order at 2**53' => ->(text) { text.sub('order: 9007199254740991', 'order: 9007199254740993') }
  }.freeze

  # Where the model deliberately refuses what Mermaid accepts: Mermaid must
  # still parse the program, and the model must refuse it.
  EXPECTED_DIFFERENCES = {
    'duplicate commit id (Mermaid overwrites the earlier commit)' => [
      "gitGraph\n  commit id: \"A\"\n  commit id: \"A\"",
      -> { Diagrams::GitgraphDiagram.new.tap { it.commit(id: 'A') }.commit(id: 'A') }
    ]
  }.freeze

  def differences(problems)
    results = parse(EXPECTED_DIFFERENCES.map { |name, (text, _)| { name:, text: } })
    EXPECTED_DIFFERENCES.zip(results).each do |(name, (_, ruby)), result|
      problems << "#{name}: Mermaid no longer accepts it: #{result['error']}" unless result['parsed']
      begin
        ruby.call
        problems << "#{name}: the model no longer refuses it"
      rescue ArgumentError
        nil
      end
    end
    EXPECTED_DIFFERENCES.size
  end

  def run
    cases = self.cases
    rendered, problems = render(cases)
    results = parse(rendered.map { |c, text| { name: c.name, text: } })
    rendered.zip(results).each { |(c, text), result| problems.concat(compare(c, text, result)) }
    problems.concat(round_trips(rendered))
    mutants = mutate(rendered, problems)
    known = differences(problems)
    puts "#{cases.size} cases: #{rendered.size} parsed by Mermaid and round-tripped, " \
         "#{cases.size - rendered.size} refused as expected; #{mutants} mutants rejected; " \
         "#{known} expected difference from Mermaid confirmed"
    abort problems.join("\n\n") if problems.any?
  end

  def compare(example, text, result)
    unless result['facts']
      state = result['parsed'] ? 'parsed, but unreadable' : 'not parsed'
      return ["#{example.name}: #{state}: #{result['error']}\n#{text}"]
    end
    want = expected(example.diagram)
    have = actual(result['facts'])
    want == have ? [] : ["#{example.name}: read back differently\n#{text}\n#{diff(want, have)}"]
  end

  def render(cases)
    problems = []
    rendered = cases.filter_map do |c|
      if c.diagram.is_a?(Exception)
        problems << "#{c.name}: refused by the model: #{c.diagram.message}" unless c.refuse
        next
      end
      text = c.diagram.to_mermaid
      problems << "#{c.name}: rendered, but must be refused" if c.refuse
      [c, text] unless c.refuse
    rescue ArgumentError => e
      problems << "#{c.name}: refused: #{e.message}" unless c.refuse
      nil
    end
    [rendered, problems]
  end

  def round_trips(rendered)
    rendered.filter_map do |c, text|
      copy = Diagrams::Base.from_json(c.diagram.to_json)
      "#{c.name}: does not round-trip" unless copy == c.diagram && copy.to_mermaid == text
    end
  end

  def mutate(rendered, problems)
    by_name = rendered.to_h { |c, text| [c.name, [c, text]] }
    mutants = MUTANTS.filter_map do |name, mutation|
      c, text = by_name[name]
      mutant = text && mutation.call(text)
      next [c, mutant] if mutant && mutant != text

      problems << "negative control for #{name.inspect} does not apply"
      nil
    end
    results = parse(mutants.map { |c, text| { name: c.name, text: } })
    mutants.zip(results).each do |(c, text), result|
      problems << "mutant of #{c.name} was accepted:\n#{text}" if compare(c, text, result).empty?
    end
    mutants.size
  end

  def parse(cases)
    Dir.mktmpdir do |dir|
      input = File.join(dir, 'cases.json')
      output = File.join(dir, 'results.json')
      File.write(input, JSON.generate(cases))
      out, status = Open3.capture2e({ 'TZ' => 'UTC' }, 'node', File.join(__dir__, 'parse.mjs'), input, output)
      abort "parse.mjs failed:\n#{out}" unless status.success?
      JSON.parse(File.read(output))
    end
  end

  def diff(want, actual)
    (want.keys | actual.keys).filter_map do |key|
      next if want[key] == actual[key]

      "  #{key}: expected #{want[key].inspect}\n  #{' ' * key.size}  got      #{actual[key].inspect}"
    end.join("\n")
  end
end

ParserCheck.run if $PROGRAM_NAME == __FILE__
