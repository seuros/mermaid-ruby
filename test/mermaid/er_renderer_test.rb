# frozen_string_literal: true

require 'test_helper'

class ERRendererTest < Minitest::Test
  def setup
    @diagram = Diagrams::ERDiagram.new
    @diagram.add_entity(name: 'CUSTOMER', attributes: [
                          { type: 'int', name: 'id', keys: [:PK] },
                          { type: 'int', name: 'account_id', keys: %i[FK UK], comment: 'the "main" one' },
                          { type: 'string', name: 'email', keys: [:UK] },
                          { type: 'string', name: 'name' }
                        ])
    @diagram.add_entity(name: 'ActiveStorage::Blob')
  end

  def test_entities_and_attributes
    assert_mermaid <<~MERMAID, @diagram
      erDiagram
        "CUSTOMER" {
          int id PK
          int account_id FK, UK "the #34;main#34; one"
          string email UK
          string name
        }
        "ActiveStorage#58;#58;Blob"
    MERMAID
  end

  def test_relationships
    @diagram.add_relationship(entity1: 'CUSTOMER', entity2: 'ActiveStorage::Blob', cardinality1: :ONE_ONLY,
                              cardinality2: :ZERO_OR_MORE, label: 'uploads')
    @diagram.add_relationship(entity1: 'CUSTOMER', entity2: 'ActiveStorage::Blob', cardinality1: :ZERO_OR_ONE,
                              cardinality2: :ONE_OR_MORE, identifying: true)

    assert_equal ['"CUSTOMER" ||..o{ "ActiveStorage#58;#58;Blob" : "uploads"',
                  '"CUSTOMER" |o--|{ "ActiveStorage#58;#58;Blob" : ""'],
                 @diagram.to_mermaid.lines.last(2).map(&:strip)
  end
end
