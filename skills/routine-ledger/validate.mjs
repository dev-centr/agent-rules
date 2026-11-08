// Validate routine-ledger JSON5 files against the JSON Schema 2020-12 set.
// Usage: node validate.mjs                 -> examples + built-in negative cases
//        node validate.mjs <schema> <file> -> one ledger file (schema = routine, run, ...)
import { readFileSync, readdirSync } from 'node:fs';
import { join, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import Ajv2020 from 'ajv/dist/2020.js';
import addFormats from 'ajv-formats';
import JSON5 from 'json5';

const here = dirname(fileURLToPath(import.meta.url));
const schemaDir = resolve(here, '../../schemas/routine-ledger');
const ajv = new Ajv2020({ allErrors: true, strict: false });
addFormats(ajv);
for (const f of readdirSync(schemaDir).filter((n) => n.endsWith('.schema.json'))) {
  ajv.addSchema(JSON.parse(readFileSync(join(schemaDir, f), 'utf8')), f);
}
const check = (name, data) => {
  const v = ajv.getSchema(`${name}.schema.json`);
  if (!v) throw new Error(`No schema ${name}`);
  return { ok: v(data), errors: v.errors };
};
const load = (p) => JSON5.parse(readFileSync(p, 'utf8'));

let failed = 0;
if (process.argv.length === 4) {
  const r = check(process.argv[2], load(process.argv[3]));
  console.log(r.ok ? 'PASS' : `FAIL ${JSON.stringify(r.errors, null, 1)}`);
  process.exit(r.ok ? 0 : 1);
}
const exDir = join(schemaDir, 'examples');
const examples = readdirSync(exDir).filter((n) => n.endsWith('.json5'));
for (const f of examples) {
  const r = check(f.replace(/\.json5$/, ''), load(join(exDir, f)));
  console.log(`${r.ok ? 'PASS' : 'FAIL'} example ${f}`);
  if (!r.ok) { failed++; console.log(JSON.stringify(r.errors, null, 1)); }
}
const clone = (f) => load(join(exDir, f));
const negatives = [
  ['pm-record contact is an email', 'pm-record', { ...clone('pm-record.json5'), contact: 'ryan@example.com' }],
  ['target unknown placeholder', 'target', { ...clone('target.json5'), url: 'https://x.invalid/{{env.HOME}}' }],
  ['target command with templated program', 'target', { schema: 'routine-ledger/target/1', id: 'x', kind: 'command', capabilities: [], program: '{{routine.prompt}}', args: [] }],
  ['target http extra field (secret value)', 'target', { ...clone('target.json5'), token: 'abc' }],
  ['watch without watch block', 'routine', (() => { const r = clone('routine.json5'); delete r.watch; return r; })()],
  ['claim without lease', 'claim-comment', (() => { const c = clone('claim-comment.json5'); delete c.lease_expires; return c; })()],
  ['complete bootstrap without completed_at', 'bootstrap-record', (() => { const b = clone('bootstrap-record.json5'); delete b.completed_at; return b; })()],
];
for (const [label, schema, data] of negatives) {
  const r = check(schema, data);
  console.log(`${r.ok ? 'FAIL' : 'PASS'} rejects: ${label}`);
  if (r.ok) failed++;
}
if (examples.length < 7) { console.log('FAIL expected 7 examples'); failed++; }
console.log(failed ? `${failed} check(s) failed` : `PASS: ${examples.length} examples valid, ${negatives.length} negative cases rejected`);
process.exit(failed ? 1 : 0);
