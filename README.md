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

A git graph replays its history. Mermaid opens a branch at the head of the
checked-out branch, so each branch is opened right after its start commit:

```ruby
git = Diagrams::GitgraphDiagram.new
git.commit(id: 'init')
git.branch(name: 'feature')
git.commit(id: 'work')
git.checkout(name: 'main')
git.merge(from_branch_name: 'feature', id: 'merge', tag: 'v1')

puts git.to_mermaid
# gitGraph
#   commit id: "init"
#   branch feature
#   commit id: "work"
#   checkout main
#   merge feature id: "merge" tag: "v1"
```

Rendering a diagram class that has no renderer raises `TypeError`.

## Development

```bash
bundle install
bundle exec rake        # tests (padded_cell on CRuby), RuboCop, RBS
bundle exec rake minitest
```

## License

MIT.
