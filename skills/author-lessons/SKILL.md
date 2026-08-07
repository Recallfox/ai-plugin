---
name: author-lessons
description: Design, create, inspect, and revise short interactive Lessons in RecallFox Learning Paths. Use when the user asks to add, build, generate, edit, reorder, or remove a Lesson, or accepts an offer to turn newly learned material into a replayable interactive lesson.
---

# Author RecallFox Lessons

A Lesson teaches one coherent idea before Recall asks the learner to retrieve it. Build a small,
purpose-made teaching experience attached to a topic, not a prose dump, slide deck, or quiz gauntlet.

## Keep creation consensual

- Never create or change a Lesson silently. An explicit request to create a specified Lesson is
  consent for that Lesson. Otherwise show one compact proposal and wait for confirmation.
- When a conversation has taught durable new material, offer at most once: “I can also add a short
  interactive Lesson to **<topic>** so you can explore it now and replay it from the Learning Path
  later. Want me to create it?” Do not offer after the user declines or says not to save it.
- Ask before creating a topic, moving a Lesson, changing authored content, reordering Lessons or
  steps, or deleting anything. Combine related choices into one confirmation instead of interrupting
  the learner with many questions.
- Do not create cards merely because a Lesson is created. Cards and Lessons have separate consent.

## Inspect before designing

1. Use `list_decks` and `list_topics` to find the least-disruptive placement and access state.
2. Use `list_cards` to inspect every card in the target topic and the cards in earlier topics. Use
   them to establish required coverage and prior knowledge without restating their prompts.
3. Use `list_lessons` on the likely topic and `get_lesson` for relevant existing Lessons. Avoid a
   duplicate objective and match the learner's current depth and vocabulary.
4. Reuse a cohesive existing topic. Propose a new topic only when the concept is a distinct stage
   with room to grow; topic creation requires confirmation.

A locked topic may still contain Lessons, but tell the user that the Lesson will become available as
that topic enters the Learning Path. Never study ahead or change path settings implicitly.

## Design for teaching

Start with the learning objective: what should become understandable that was not understandable
before? Teach one objective per Lesson. Prefer two to five short steps and roughly five to ten
minutes, but let the concept determine the structure.

### Important: topic cards are the minimum teaching scope

- The Lesson must, at minimum, teach the knowledge needed to understand and answer every card in
  its target topic. Do not omit a card's underlying knowledge merely to keep the Lesson shorter.
- Cover the knowledge, not the card wording. Do not turn the Lesson into a walkthrough or repetition
  of card prompts. If the required coverage cannot fit one coherent objective, propose multiple
  Lessons rather than silently leaving cards uncovered.
- The Lesson may go a little beyond this minimum when an explanation, example, or connection makes
  the required knowledge easier to understand. Keep the extension relevant and proportionate.
- A relevant prerequisite that earlier topics do not cover is useful to include, but is a
  nice-to-have rather than required coverage. Prerequisites already taught in earlier topics may be
  assumed or connected briefly instead of being taught again.

Favor this sequence when it fits:

1. Establish a concrete situation or visual mental model.
2. Show an example changing over time or in response to an input.
3. Let the learner change a meaningful value, move an object, choose a branch, or replay the flow.
4. Explain the result and connect it to the underlying idea.
5. Optionally use one lightweight understanding check before returning to Recall.

Do not force this sequence onto every subject. A clear annotated explanation can be the right
Lesson. Interaction is preferred when it makes the mechanism observable, not as decoration.

### Teaching quality bar

- Show, simulate, or compare before asking the learner to recall terminology.
- Make examples specific enough that the learner can predict what changes and then see why.
- Let controls modify the model itself. A button that only reveals hidden prose is weak interaction.
- When animation explains a sequence, make every explanatory state persistent and readable. An
  automatic play mode may demonstrate the full idea, but also provide visible Pause, Previous,
  Next, and Replay controls so the learner can inspect the sequence at their own pace. Never make
  the learner race transient text; keep the current explanation visible until the state advances.
- Give immediate, explanatory feedback. Avoid scores, streaks, countdowns, repeated drills, and
  language implying that Lesson completion proves mastery.
- Use at most one or two questions, only for a misconception worth surfacing. A Lesson may contain no
  question at all.
- Keep each step independently understandable and useful on replay. RecallFox owns Back, Continue,
  Done, progress, persistence, and exit controls; do not reproduce them inside the frame.
- Prefer plain browser HTML, CSS, and JavaScript. Select a library only when it materially simplifies
  the teaching model or makes it clearer.

### Make interactions discoverable

- Use a range slider for a continuous quantity or many meaningful values. For two to four discrete
  states, prefer labelled buttons, a segmented control, tabs, or Previous/Next controls so the
  learner does not need a long or precise drag. If discrete slider stops are still the clearest
  model, show labelled stops, snap exactly to them, and provide a tap/button alternative.
- Make clickability visible before interaction. Use semantic controls with a distinct resting shape,
  border, or fill; add hover, `:focus-visible`, pressed/selected, and disabled states; and use
  `cursor: pointer` for enabled controls on pointer devices. Do not rely on color alone.
- Put a short, specific action hint next to each meaningful interaction: “Tap a stage,” “Drag the
  marker or use the arrow buttons,” “Choose an outcome,” or “Check the factors.” Prefer `Tap` over
  `Click` when the same control is used on phones.
- Do not hide the primary instruction in a tooltip. An info control may hold optional detail, but it
  must open on tap and keyboard activation as well as hover/focus. Give it an accessible name and a
  44 × 44 CSS-pixel target.
- On phones, preserve visible control affordances and the action hint because hover is unavailable.
  For tabs or segmented controls, keep every option labelled and the current selection obvious.
- After interaction, update `aria-pressed` or `aria-selected` and provide immediate explanatory
  feedback. Test the resting, hover/focus, active, and completed states at 393 × 852 and 320px wide.

Use this native starter when optional interaction help is useful. The essential instruction remains
visible; the info bubble adds detail and works without JavaScript:

```html
<div class="interaction-head">
  <p class="action-hint"><span aria-hidden="true">☝</span> Tap a stage to compare.</p>
  <details class="help">
    <summary aria-label="How to use this interaction">i</summary>
    <div class="help-pop">Tap any labelled stage. With a keyboard, use Tab and Enter.</div>
  </details>
</div>
<style>
  .interaction-head { display:flex; align-items:center; justify-content:space-between; gap:12px; }
  .action-hint { margin:0; color:var(--muted-foreground, #577770); font-weight:700; }
  button, [role="button"], [role="tab"], .help summary { cursor:pointer; }
  button { transition:background-color .15s ease, transform .15s ease, box-shadow .15s ease; }
  button:hover { background:var(--secondary, #e6f3f1); box-shadow:0 3px 10px #0f766e24; }
  button:active { transform:translateY(1px); }
  button:focus-visible, .help summary:focus-visible {
    outline:3px solid var(--ring, #0f766e); outline-offset:2px;
  }
  .help { position:relative; flex:0 0 auto; }
  .help summary {
    display:grid; place-items:center; width:44px; height:44px; list-style:none;
    border:2px solid var(--border, #dcebe8); border-radius:50%; font-weight:900;
  }
  .help summary::-webkit-details-marker { display:none; }
  .help-pop {
    display:none; position:absolute; z-index:5; right:0; top:50px;
    width:min(16rem, calc(100vw - 3.5rem)); padding:12px; border-radius:10px;
    background:#0f2e2e; color:#fff; box-shadow:0 8px 22px #0f2e2e33;
  }
  .help[open] .help-pop, .help:hover .help-pop, .help:focus-within .help-pop { display:block; }
  @media (hover:none) { .help:not([open]) .help-pop { display:none; } }
  @media (prefers-reduced-motion:reduce) { button { transition:none; } }
</style>
```

## Build within the frame contract

- Store a body fragment only. Do not emit `<!doctype>`, `<html>`, `<head>`, or `<body>`.
- Inline `<style>` and `<script>` are allowed. Do not add imports, package URLs, or CDN tags.
- Pass each step's exact optional library ids through `libraries`. An empty list is normal.
- Design responsively for the real 393 × 852 phone test viewport, a 320 CSS-pixel minimum width,
  and a desktop content column up to 1024 CSS pixels. The frame height is fluid, so allow vertical
  scrolling and never hide essential content below a fixed-height canvas.
- Use touch targets of at least 44 × 44 CSS pixels, body text of at least 16px inside the frame,
  visible focus states, semantic controls, labels, and non-color-only feedback.
- Avoid horizontal page scrolling, hover-only meaning, keyboard-only operation, and drag as the sole
  way to complete an interaction.
- The default frame canvas is white. Use the RecallFox palette when it supports the explanation, but
  choose another accessible palette, additional semantic colors, or a white-first scientific canvas
  when the concept is clearer that way. Teaching clarity outranks visual branding.
- Do not fetch, submit, navigate, open windows, load external media, collect personal data, imitate
  trusted RecallFox prompts, or depend on cookies/storage. The sandbox intentionally blocks these.

## Runtime reference

RecallFox wraps each stored step in a generated document and renders it in an iframe with
`sandbox="allow-scripts"`. The frame has an opaque origin and no RecallFox account authority. Its
content security policy blocks network connections, form submission, objects, media, external
images, and all scripts/styles except inline code and selected same-origin assets. Images must be
`data:` or `blob:` values. Do not use `fetch`, XHR, WebSocket, EventSource, external URLs, cookies,
local storage, navigation, popups, or `parent.postMessage`.

RecallFox injects selected libraries before the body fragment. Use their browser globals; do not
import them or add `<script src>`/`<link>` tags. RecallFox owns progress and navigation outside the
frame. The frame does not mark itself complete, and Escape handling is bridged automatically.

### Canvas and visual baseline

- Canonical phone QA viewport: **393 × 852 CSS pixels**.
- Minimum supported content width: **320 CSS pixels**.
- Desktop Lesson column: fluid up to **1024 CSS pixels**.
- Height: the remaining dynamic viewport after RecallFox chrome and controls; it is not fixed.

Use `width: 100%`, responsive grid/flex wrapping, and `max-width` for readable prose. Let the body
scroll vertically. Make SVG/canvas responsive and recalculate dimensions with `ResizeObserver` when
needed. Do not use a fixed desktop artboard or rely on `100vh` inside the frame.

The frame canvas and cards default to white. RecallFox injects CSS variables including `--primary`,
`--primary-foreground`, `--secondary`, `--muted`, `--muted-foreground`, `--accent`, `--border`,
`--ring`, `--font-sans`, and `--font-mono`. The stable light baseline is:

| Role | Value |
| --- | --- |
| Canvas/card | `#ffffff` |
| Main text | `#0f2e2e` |
| Primary teal | `#0f766e` |
| Primary text | `#ffffff` |
| Secondary surface/text | `#e6f3f1` / `#0f3d38` |
| Muted surface/text | `#eef5f4` / `#577770` |
| Accent surface | `#ccfbf1` |
| Border | `#dcebe8` |
| Focus ring | `#0f766e` |
| Destructive/error | `#b93b34` |

Use the injected variables when this scheme fits. It is optional: a white scientific canvas,
categorical visualization colors, or a concept-specific palette is welcome when it explains the
subject better. Maintain WCAG AA contrast, avoid color-only meaning, and keep fox orange out of
ordinary controls. Figtree is available through `var(--font-sans)` and IBM Plex Mono through
`var(--font-mono)`.

### Native starter fragment

This needs `libraries: []`:

```html
<section class="lesson-demo">
  <h2>See latency accumulate</h2>
  <label for="hops">Network hops: <output id="value">3</output></label>
  <input id="hops" type="range" min="1" max="8" value="3">
  <p id="result" aria-live="polite"></p>
</section>
<style>
  .lesson-demo { max-width: 42rem; margin: auto; padding: 24px; }
  h2 { margin-top: 0; font-size: clamp(1.5rem, 6vw, 2.25rem); }
  input { width: 100%; min-height: 44px; accent-color: var(--primary, #0f766e); }
  #result { padding: 16px; border-radius: 12px; background: #eef5f4; }
</style>
<script>
  const input = document.querySelector('#hops');
  const value = document.querySelector('#value');
  const result = document.querySelector('#result');
  function render() {
    value.value = input.value;
    result.textContent = `${input.value} hops × 20 ms = ${Number(input.value) * 20} ms`;
  }
  input.addEventListener('input', render);
  render();
</script>
```

## Optional library catalog

These exact globals were checked against npm on 2026-08-06. They are the newest stable releases old
enough to pass RecallFox's 21-day dependency quarantine. A newer npm tag may therefore exist. Every
library is optional and selected independently per step.

### `alpine` — Alpine.js 3.15.12 (`Alpine`)

Use for small declarative state, input binding, conditional explanations, and repeated markup.
[Official start guide](https://alpinejs.dev/start-here).

```html
<div x-data="{ packets: 1 }">
  <input type="range" min="1" max="5" x-model.number="packets">
  <p><strong x-text="packets"></strong> packet<span x-show="packets !== 1">s</span></p>
</div>
```

### `motion` — Motion 12.42.2 (`Motion`)

Use for an explanatory transition, path, sequence, or replayable state change. For a multi-state
explanation, support both automatic playback and learner-controlled Previous/Next navigation; add
Pause while automatic playback is running and Replay when it finishes.
[Official quick start](https://motion.dev/docs/quick-start).

```html
<button id="send">Send packet</button><div id="packet" aria-label="Packet"></div>
<script>
  const { animate } = Motion;
  document.querySelector('#send').addEventListener('click', () => {
    animate('#packet', { x: [0, 220], opacity: [1, 1, 0] }, { duration: 1.2 });
  });
</script>
```

### `interact` — interact.js 1.10.27 (`interact`)

Use for drag, resize, drop-zone, or gesture models. Always provide tap/button and keyboard
alternatives. [Official draggable guide](https://interactjs.io/docs/draggable/).

```html
<div class="token" tabindex="0">Packet</div>
<style>.token { touch-action: none; user-select: none; }</style>
<script>
  const position = { x: 0, y: 0 };
  interact('.token').draggable({ listeners: { move(event) {
    position.x += event.dx; position.y += event.dy;
    event.target.style.transform = `translate(${position.x}px, ${position.y}px)`;
  } } });
</script>
```

### `katex` — KaTeX 0.17.0 (`katex`)

Use for readable mathematical notation. RecallFox injects its matching stylesheet and fonts. Prefer
`throwOnError: false`. [Official browser guide](https://katex.org/docs/browser.html).

```html
<p id="formula" aria-label="Energy equals mass times the speed of light squared"></p>
<script>
  katex.render('E = mc^2', document.querySelector('#formula'), { throwOnError: false });
</script>
```

### `d3` — D3 7.9.0 (`d3`)

Use for data-bound SVG, scales, axes, transitions, and exploratory charts. Prefer responsive
`viewBox` SVG over a fixed width. [Official getting-started guide](https://d3js.org/getting-started).

```html
<svg id="chart" viewBox="0 0 320 120" role="img" aria-label="Latency by hop"></svg>
<script>
  const values = [18, 42, 61, 85];
  d3.select('#chart').selectAll('rect').data(values).join('rect')
    .attr('x', (_, i) => i * 76).attr('y', d => 110 - d)
    .attr('width', 56).attr('height', d => d).attr('fill', '#0f766e');
</script>
```

### `cytoscape` — Cytoscape.js 3.34.0 (`cytoscape`)

Use for networks, dependency graphs, state graphs, and paths the learner should inspect or
manipulate. Give the container a responsive height. [Official API and examples](https://js.cytoscape.org/).

```html
<div id="graph" style="height:320px"></div>
<script>
  const cy = cytoscape({ container: document.querySelector('#graph'),
    elements: [
      { data: { id: 'client' } }, { data: { id: 'server' } },
      { data: { id: 'request', source: 'client', target: 'server' } }
    ],
    layout: { name: 'grid', rows: 1 }
  });
</script>
```

### `p5` — p5.js 2.3.0 (`p5`)

Use for dynamic canvas simulations, geometry, physics, procedural models, or continuous input. Use
instance mode to avoid global-name collisions. [Official reference](https://p5js.org/reference/).

```html
<div id="sketch"></div>
<script>
  new p5(p => {
    p.setup = () => p.createCanvas(320, 180).parent('sketch');
    p.draw = () => { p.background(255); p.circle(p.mouseX, 90, 24); };
  });
</script>
```

### `mermaid` — Mermaid 11.16.0 (`mermaid`)

Use for a flowchart, sequence, state, or relationship diagram. Initialize explicitly and retain
strict security. [Official usage guide](https://mermaid.js.org/config/usage.html).

```html
<pre class="diagram">sequenceDiagram
  Client->>Server: GET /resource
  Server-->>Client: 200 OK</pre>
<script>
  mermaid.initialize({ startOnLoad: false, securityLevel: 'strict' });
  mermaid.run({ nodes: document.querySelectorAll('.diagram') });
</script>
```

### Selection guide

| Need | Prefer |
| --- | --- |
| Simple values, toggles, branching text | Native JS or `alpine` |
| Purposeful motion or a replayable transition | `motion` |
| Drag/drop, resize, direct manipulation | `interact` |
| Typeset mathematics | `katex` |
| Data-driven SVG or charts | `d3` |
| Interactive node/edge networks | `cytoscape` |
| Continuous visual simulation or canvas sketch | `p5` |
| Flow, sequence, state, or relationship diagram | `mermaid` |

Do not select a library merely because it is available. Native code plus one focused library is
usually more reliable and easier to replay on a phone.

## Propose, create, and verify

Before a write, show only what the user needs to judge:

- target deck and topic, including locked/unlocked consequence;
- one-sentence objective and estimated duration;
- step outline and the meaningful interaction, if any;
- optional libraries and why each is needed.

Do not dump the full HTML into the confirmation unless the user asks to review source. After consent,
prefer one `create_lesson` call with all steps. Use the exact connected schema and pass `libraries: []`
for native-only steps. Then call `get_lesson` and `list_lessons` to verify content, order, and placement.

For edits, inspect the full Lesson first. Preserve step identities when updating HTML. Reordering must
pass every current id exactly once. Never delete the only step or a step holding learner progress.
After any mutation, summarize the resulting Lesson and where the learner can find or replay it.

## MCP tools

- Inspect context: `list_decks`, `list_topics`, `list_cards`.
- Inspect Lessons: `list_lessons`, `get_lesson`.
- Create: `create_lesson`, `add_lesson_step`.
- Revise: `update_lesson`, `update_lesson_step`.
- Organize: `reorder_lesson_steps`, `reorder_lessons`.
- Remove: `delete_lesson_step`, `delete_lesson`.

Use the connected tool schemas rather than guessing arguments. Lesson authoring tools do not start,
complete, skip, or reset the learner's progress.
