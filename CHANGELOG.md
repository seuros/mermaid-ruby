## [Unreleased]

## [0.1.0](https://github.com/seuros/mermaid-ruby/compare/mermaid/v0.0.6...mermaid/v0.1.0) (2026-11-16)


### ⚠ BREAKING CHANGES

* one renderer per diagram type, valid Mermaid 11 output

### Features

* one renderer per diagram type, valid Mermaid 11 output ([0f97cdb](https://github.com/seuros/mermaid-ruby/commit/0f97cdbea415c7485df267fc6abfe870001dad1d))


### Bug Fixes

* check the gantt year 0100 floor against Mermaid ([680ca93](https://github.com/seuros/mermaid-ruby/commit/680ca93b7891ba31bc7b01523905d7957d60420a))
* keep explicit merge types, declare the gantt date format; check evaluated dates ([c48bc04](https://github.com/seuros/mermaid-ruby/commit/c48bc04942fcc8be4d377fc1d8be5e7d12cbd91d))
* lock for JRuby and the public npm registry ([b86107b](https://github.com/seuros/mermaid-ruby/commit/b86107b3ee7564d3389d07559a0344fc97f66504))
* parser check uses js-yaml 4.3.2 ([5dbfca4](https://github.com/seuros/mermaid-ruby/commit/5dbfca43e7fa0683f031b7fa1cd83430362e3e4b))
* render the gitGraph program, cherry-picks included; stronger parse check ([78bc1a0](https://github.com/seuros/mermaid-ruby/commit/78bc1a0a5449531cdbcc4c20fd3002d582483394))
* text stays text, ids are aliased, output checked by Mermaid's parser ([0fbbf5f](https://github.com/seuros/mermaid-ruby/commit/0fbbf5fe2fe3b63c33742b739601a55eaa1539df))

## [0.0.6](https://github.com/seuros/mermaid-ruby/compare/mermaid/v0.0.5...mermaid/v0.0.6) (2025-08-14)


### Bug Fixes

* conform to mermaid standard syntax. This will allow user to gene… ([9081725](https://github.com/seuros/mermaid-ruby/commit/90817257b7b7a8bab28b1aff250ee5ac83eaa85c))
* conform to mermaid standard syntax. This will allow user to generate ERD compatible with Github ([f6574b5](https://github.com/seuros/mermaid-ruby/commit/f6574b54f959f15e9d37f88709fe21b77987293a))

## [0.0.5](https://github.com/seuros/mermaid-ruby/compare/mermaid/v0.0.4...mermaid/v0.0.5) (2025-07-11)


### Bug Fixes

* eager load the gem ([9f10fff](https://github.com/seuros/mermaid-ruby/commit/9f10fff38d6b2edb59a28a6611948d97ca6e5e6e))

## [0.0.4](https://github.com/seuros/mermaid-ruby/compare/mermaid/v0.0.3...mermaid/v0.0.4) (2025-05-20)


### Bug Fixes

* documentation update ([429bb89](https://github.com/seuros/mermaid-ruby/commit/429bb899a2041392d2ad3ea6f93e9fa0cb6290b6))

## [0.0.3](https://github.com/seuros/mermaid-ruby/compare/mermaid/v0.0.2...mermaid/v0.0.3) (2025-04-01)


### Features

* add ERD diagram representation ([8d081d4](https://github.com/seuros/mermaid-ruby/commit/8d081d44491d64a63c6ca850b22b01d6e456311d))

## 0.0.2 (2025-04-01)


### Features

* add ClassDiagram generator ([364782e](https://github.com/seuros/mermaid-ruby/commit/364782e86827e2fe5745e7177ab954cb5ddc3a6a))
* add release flow ([2ed9710](https://github.com/seuros/mermaid-ruby/commit/2ed9710d6f8820a91aa6f19bef4d4388a5b0bc31))
* fix diagram inital implementation ([fab6bfa](https://github.com/seuros/mermaid-ruby/commit/fab6bfa94b932902e4664d551406c77c4037f950))
* Implemented #to_mermaid functionality for StateDiagram, ClassDiagram, PieDiagram, FlowchartDiagram, GanttDiagram, GitgraphDiagram, and TimelineDiagram by creating renderer modules ([7ab6486](https://github.com/seuros/mermaid-ruby/commit/7ab64865e1cbf6a41df23aa971f8fad79a8ba274))


### Bug Fixes

* correct releaser ([2eee28c](https://github.com/seuros/mermaid-ruby/commit/2eee28cf78d9c948ea9c8a034ba48e3b12aa0c13))

## [0.1.0] - 2024-01-23

- Draft release
