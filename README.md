# mermaid

[![Gem Version](https://badge.fury.io/rb/mermaid.svg)](https://badge.fury.io/rb/mermaid)

[Mermaid](https://mermaid.js.org) text for the diagrams of the
[diagram](https://github.com/seuros/diagram-ruby) gem. Requiring it gives
every diagram a `to_mermaid` method; the diagrams themselves stay plain data.

Supported: flowchart, state, class, ER, Gantt, pie, timeline and git graph.
Ruby 4.0+.

## Installation

```ruby
gem 'mermaid'
```

## Usage

```ruby
require 'mermaid'

door = Diagrams::StateDiagram.new(title: 'Door')
door.add_state(id: 'closed')
door.add_state(id: 'open', label: 'Open')
door.add_transition(source_state_id: '*', target_state_id: 'closed')
door.add_transition(source_state_id: 'closed', target_state_id: 'open', label: 'push', guard: 'unlocked')

puts door.to_mermaid
# ---
# title: "Door"
# ---
# stateDiagram-v2
#   closed
#   open : Open
#   [*] --> closed
#   closed --> open : push [unlocked]
```

A title goes to the YAML front matter, except for pie, Gantt and timeline
diagrams, which have a `title` statement of their own:

```ruby
pets = Diagrams::PieDiagram.new(title: 'Pets')
pets.add_slice(label: 'Dogs', value: 3)
pets.add_slice(label: 'Cats', value: 1.5)

puts pets.to_mermaid
# pie
#   title Pets
#   "Dogs" : 3
#   "Cats" : 1.5
```

ER attributes render their keys the Mermaid way (`int id PK, FK`), and a
relationship is drawn solid only when it is identifying:

```ruby
shop = Diagrams::ERDiagram.new
shop.add_entity(name: 'CUSTOMER', attributes: [{ type: 'int', name: 'id', keys: [:PK] }])
shop.add_entity(name: 'ORDER')
shop.add_relationship(entity1: 'CUSTOMER', entity2: 'ORDER',
                      cardinality1: :ONE_ONLY, cardinality2: :ZERO_OR_MORE, label: 'places')

puts shop.to_mermaid
# erDiagram
#   "CUSTOMER" {
#     int id PK
#   }
#   "ORDER"
#   "CUSTOMER" ||..o{ "ORDER" : "places"
```

A git graph is already a gitGraph program (the diagram gem models Mermaid's
statements and refusals), so each statement renders as the one it models.
A cherry-pick names its source; Mermaid generates the picked commit's id:

```ruby
git = Diagrams::GitgraphDiagram.new
git.commit(id: 'init')
git.branch(name: 'feature', order: 1)
git.commit(id: 'work', message: 'the work')
git.checkout(name: 'main')
git.commit(id: 'fix', tags: ['v1.0.1'])
git.merge(branch: 'feature', id: 'merge', tags: ['v1'])
git.checkout(name: 'feature')
git.cherry_pick(commit_id: 'fix')

puts git.to_mermaid
# gitGraph
#   commit id: "init"
#   branch "feature" order: 1
#   commit id: "work" msg: "the work"
#   checkout "main"
#   commit id: "fix" tag: "v1.0.1"
#   merge "feature" id: "merge" tag: "v1"
#   checkout "feature"
#   cherry-pick id: "fix"
```

## Text and names

Text reaches Mermaid as text. Any character Mermaid could read as syntax (a
quote, colon, `#`, `%`, a line break, markup) is written as a numeric entity
(`#58;`), which Mermaid turns back into the character when it draws; names
Mermaid cannot read as identifiers are aliased (`n0`, `s0`, `c0`) and shown
as their label:

```ruby
states = Diagrams::StateDiagram.new
states.add_state(id: 'Billing::Invoice', label: 'Paid: done')

puts states.to_mermaid
# stateDiagram-v2
#   state "Paid#58; done" as s0
```

What Mermaid cannot carry is refused with `ArgumentError` rather than drawn
differently: class members that would break the class block or be read as
the wrong kind of member (members are Mermaid notation, such as
`+save() bool`; an annotation such as `<<interface>>` is not a member), a
main branch name that needs entity codes, and titles holding Mermaid's entity
placeholders. Gantt tasks need no refusal here: the diagram gem only accepts
the forms Mermaid evaluates. Rendering a diagram class that has no renderer
raises `TypeError`.

`rake parse` renders a battery of diagrams, hostile text included, parses each
with Mermaid's own parser (Node; `npm ci --prefix parser` first) and checks
that Mermaid reads back the same model: which node is which, labels, links and
their kind, values, commits and lanes, and the start and end Mermaid computes
for every Gantt task (Gantt output declares `dateFormat YYYY-MM-DD`, without
which Mermaid ignores end dates). Every case also round-trips through JSON,
negative controls (mutated output) must be rejected, and the one deliberate
difference (a duplicate commit id, which Mermaid overwrites and the diagram
gem refuses) is confirmed on both sides.

## Development

```bash
bundle install
bundle exec rake        # tests (padded_cell on CRuby), RuboCop, RBS
bundle exec rake minitest
npm ci --prefix parser && bundle exec rake parse   # Mermaid's parser check
```

## License

MIT.
