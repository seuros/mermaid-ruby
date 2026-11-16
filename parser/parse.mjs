// Parses Mermaid text with Mermaid's own parser and reports what it understood.
// Run it with TZ=UTC: Gantt times are evaluated in the local zone.
//
//   node parser/parse.mjs cases.json results.json
//
// cases.json is [{name, text}]. For each case the result holds `parsed`,
// `error`, and `facts`: the diagram's model as Mermaid's database holds it,
// with entity codes (#35;) decoded back to characters, so the caller can
// compare it with the model it rendered. Rendering needs a browser; this is
// the parser alone. Mermaid's database calls the HTML sanitizer even when
// only parsing, so DOMPurify is replaced by the identity: the lexers and
// grammars are untouched, but HTML sanitizing is not exercised.
import fs from 'node:fs';
import DOMPurify from 'dompurify';
import yaml from 'js-yaml';

DOMPurify.sanitize = text => text;
DOMPurify.addHook = () => {};
const { default: mermaid } = await import('mermaid/dist/mermaid.core.mjs');
mermaid.initialize({ startOnLoad: false, securityLevel: 'strict' });

// Mermaid swaps #NNN; for placeholders before lexing and back after
// rendering. Whitespace the grammar captured around a value is not part of it.
const text = value => (value ?? '').trim().replace(/ﬂ°°(\d+)¶ß/g, (_, code) => String.fromCodePoint(Number(code)));
const entries = map => (map instanceof Map ? [...map.entries()] : Object.entries(map ?? {}));

// Facts keep Mermaid's own ids, so the caller can match them to the model
// by declaration order: two nodes with the same label stay two nodes.
const facts = {
  flowchart(db) {
    return {
      nodes: [...new Map(entries(db.getVertices())).values()].map(v => [v.id, text(v.text)]),
      edges: db.getEdges().map(edge => [edge.start, edge.end, text(edge.text)])
    };
  },
  state(db) {
    const terminal = id => (/^root_(start|end)$/.test(id) ? '*' : id);
    return {
      states: entries(db.getStates()).filter(([id]) => terminal(id) !== '*')
        .map(([id, state]) => [id, text(state.descriptions?.[0] ?? id)]),
      transitions: db.getRelations().map(rel => [terminal(rel.id1), terminal(rel.id2), text(rel.relationTitle)])
    };
  },
  class(db) {
    const member = item => text(item.text).replace(/^\\/, '');
    return {
      classes: [...new Map(entries(db.getClasses())).values()]
        .map(c => [c.id, text(c.label), c.members.map(member), c.methods.map(member)]),
      relationships: db.getRelations().map(rel => [
        rel.id1, rel.id2, text(rel.title), rel.relation.type1, rel.relation.type2, rel.relation.lineType
      ])
    };
  },
  er(db) {
    const entities = entries(db.getEntities());
    return {
      entities: entities.map(([name, entity]) => [
        entity.id, text(name),
        entity.attributes.map(a => [text(a.type), text(a.name), a.keys ?? [], text(a.comment)])
      ]),
      relationships: db.getRelationships().map(rel => [
        rel.entityA, rel.entityB, text(rel.roleA), rel.relSpec.cardB, rel.relSpec.cardA, rel.relSpec.relType
      ])
    };
  },
  pie(db) {
    return { slices: entries(db.getSections()).map(([label, value]) => [text(label), value]) };
  },
  gantt(db) {
    return {
      sections: db.getSections().map(text),
      tasks: db.getTasks().map(task => [
        text(task.section), text(task.task), task.id,
        ['done', 'active', 'crit', 'milestone'].find(status => task[status]) ?? null,
        task.startTime.getTime(), task.endTime.getTime()
      ])
    };
  },
  timeline(db) {
    return {
      sections: db.getSections().map(text),
      periods: db.getTasks().map(task => [text(task.section), text(task.task), task.events.map(text)])
    };
  },
  gitGraph(db) {
    const commits = [...db.getCommits().values()].sort((a, b) => a.seq - b.seq);
    return {
      lanes: db.getBranchesAsObjArray().map(branch => text(branch.name)),
      commits: commits.map(c => [
        text(c.id), text(c.branch), c.parents.map(text), c.tags.map(text), c.type, c.customType ?? null,
        text(c.message)
      ])
    };
  }
};

// Front matter as Mermaid reads it: title and config come from YAML.
function frontMatter(source) {
  const match = source.match(/^---\n([\s\S]*?)\n---\n/);
  return match ? { meta: yaml.load(match[1]) ?? {}, body: source.slice(match[0].length) } : { meta: {}, body: source };
}

const [input, output] = process.argv.slice(2);
const results = [];
for (const { name, text: source } of JSON.parse(fs.readFileSync(input, 'utf8'))) {
  const result = { name, parsed: false };
  try {
    await mermaid.parse(source);
    result.parsed = true;
    const { meta, body } = frontMatter(source);
    const diagram = await mermaid.mermaidAPI.getDiagramFromText(body);
    const kind = diagram.type.replace(/-v2$/, '').replace(/Diagram$/, '');
    result.facts = { ...facts[kind === 'flowchart' ? 'flowchart' : kind](diagram.db), title: meta.title ?? null };
    if (kind === 'gitGraph') result.facts.mainBranch = meta.config?.gitGraph?.mainBranchName ?? 'main';
    if (kind === 'pie' || kind === 'gantt' || kind === 'timeline') {
      result.facts.title = text(diagram.db.getDiagramTitle?.() ?? diagram.db.getCommonDb?.().getDiagramTitle?.()) || null;
    }
  } catch (error) {
    result.error = String(error?.message ?? error).split('\n').slice(0, 4).join(' ');
  }
  results.push(result);
}
fs.writeFileSync(output, JSON.stringify(results, null, 1));
