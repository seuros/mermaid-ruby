# Mermaid Ruby

[![Gem Version](https://badge.fury.io/rb/mermaid.svg)](https://badge.fury.io/rb/mermaid)
[![Build Status](https://github.com/seuros/mermaid-ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/seuros/mermaid-ruby/actions/workflows/ci.yml)

This gem provides Mermaid syntax generation capabilities for diagram objects created using the [`diagram`](https://github.com/seuros/diagram-ruby) gem.

It achieves this by adding renderer to the `diagram` gem (like `Diagrams::ClassDiagram`, `Diagrams::StateDiagram`, etc.) to add a `#to_mermaid` instance method.

## Installation

Add these lines to your application's Gemfile:

```ruby
gem 'diagram' # The base gem for creating diagram objects
gem 'mermaid' # This gem, for generating Mermaid syntax
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install diagram mermaid
```

## Usage

Simply require the `mermaid` gem after requiring `diagrams`. This will automatically add the `#to_mermaid` method to the diagram classes.

```ruby
require 'diagrams'
require 'mermaid' # This applies the patches

# --- Example: State Diagram ---
state_a = Diagrams::Elements::State.new(id: 'A', label: 'State A')
state_b = Diagrams::Elements::State.new(id: 'B')
transition1 = Diagrams::Elements::Transition.new(source_state_id: '*', target_state_id: 'A')
transition2 = Diagrams::Elements::Transition.new(source_state_id: 'A', target_state_id: 'B', label: 'Event X')

state_diagram = Diagrams::StateDiagram.new(
  states: [state_a, state_b],
  transitions: [transition1, transition2]
)

puts state_diagram.to_mermaid
# Output:
# stateDiagram-v2
#   A : State A
#   [*] --> A
#   A --> B : Event X

# --- Example: Class Diagram ---
class_animal = Diagrams::Elements::ClassEntity.new(name: 'Animal', attributes: ['+String name'])
class_dog = Diagrams::Elements::ClassEntity.new(name: 'Dog', attributes: ['+String breed'], methods: ['+bark() void'])
rel_inheritance = Diagrams::Elements::Relationship.new(
  source_class_name: 'Dog',
  target_class_name: 'Animal',
  type: 'inheritance'
)

class_diagram = Diagrams::ClassDiagram.new(
  classes: [class_animal, class_dog],
  relationships: [rel_inheritance]
)

puts class_diagram.to_mermaid
# Output:
# classDiagram
# class Animal {
#   +String name
# }
# class Dog {
#   +String breed
#   +bark() void
# }
# Dog <|-- Animal

# --- Example: Flowchart ---
node1 = Diagrams::Elements::Node.new(id: 'n1', label: 'Start')
node2 = Diagrams::Elements::Node.new(id: 'n2', label: 'Process')
edge1 = Diagrams::Elements::Edge.new(source_id: 'n1', target_id: 'n2', label: 'Go')

flowchart = Diagrams::FlowchartDiagram.new(nodes: [node1, node2], edges: [edge1])

puts flowchart.to_mermaid
# Output:
# graph TD
#   n1["Start"]
#   n2["Process"]
#   n1 -- "Go" --> n2

# --- Example: Pie Chart ---
slice1 = Diagrams::Elements::Slice.new(label: 'Work', value: 8)
slice2 = Diagrams::Elements::Slice.new(label: 'Sleep', value: 8)
slice3 = Diagrams::Elements::Slice.new(label: 'Play', value: 8)

pie_chart = Diagrams::PieDiagram.new(title: 'Daily Routine', slices: [slice1, slice2, slice3])

puts pie_chart.to_mermaid
# Output:
# pie
# title Daily Routine
# "Work" : 8
# "Sleep" : 8
# "Play" : 8

# --- Example: Gantt Chart ---
task1 = Diagrams::Elements::Task.new(id: 't1', name: 'Phase 1', start_date: '2024-01-01', end_date: '2024-01-10')
task2 = Diagrams::Elements::Task.new(id: 't2', name: 'Phase 2', start_date: '2024-01-11', end_date: '2024-01-20')

gantt_chart = Diagrams::GanttDiagram.new(title: 'Project Timeline', tasks: [task1, task2])

puts gantt_chart.to_mermaid
# Output:
# gantt
# title Project Timeline
# : Phase 1 : t1, 2024-01-01, 2024-01-10
# : Phase 2 : t2, 2024-01-11, 2024-01-20

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/mermaid/version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seuros/mermaid-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
