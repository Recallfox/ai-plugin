---
name: author-lessons
description: Design, create, inspect, and revise short, clear, example-led interactive Lessons in RecallFox Learning Paths. Use when the user asks to add, build, generate, edit, reorder, or remove a Lesson, or accepts an offer to turn newly learned material into a replayable interactive lesson.
---

# Author RecallFox Lessons

A Lesson makes one coherent idea understandable before Recall asks the learner to retrieve it. Build
a short teaching experience, not a prose dump, slide deck, or quiz sequence.

When a deck needs several objectives, build a coordinated Lesson set. Together, the Lessons must
teach the knowledge in every card in the deck.

A topic can contain multiple focused Lessons. The topic defines a learning stage. Each Lesson
teaches one coherent objective. Let the knowledge scope and cognitive load determine the number of
Lessons.

## Inspect before planning

1. Use `list_decks` and `list_topics` to find the least disruptive placement and its access state.
2. Use `list_cards` to inspect every card in the target deck across all topics. Read every result
   page. Record every card id and its complete educational content.
3. Use `list_lessons` on the target topic and every earlier topic. Read every result page. Use
   `get_lesson` to inspect each Lesson that can teach a prerequisite or related concept.
4. Build the learner's starting point from saved Lesson content and topic order. Do not infer prior
   knowledge from a Lesson title. Mark each prerequisite as taught, partly taught, or missing.
5. Avoid duplicate objectives. Match the learner's current depth and terminology.
6. Reuse cohesive topics. Propose a new topic only for a distinct learning stage with room to grow.

A locked topic can contain Lessons. Tell the user that the Lesson becomes available when the topic
enters the Learning Path. Do not study ahead or change path settings without permission.

## Prepare a private lesson brief

Prepare this brief before writing HTML:

- target deck, topic, and access state;
- learner starting point based on actual earlier Lesson content;
- one coherent objective for each proposed Lesson;
- a private, literal deck coverage ledger with one entry for every card id;
- prerequisites that are taught, partly taught, or missing;
- likely misconceptions;
- the main teaching example and any guided learner action;
- whether each central step is text-only, visual, or interactive, with one teaching reason;
- exact Lesson and step titles;
- the purpose of each visual, interaction, question, image, or library.

Use the instructional rules at the end of this file to prepare the brief. If the deck knowledge
does not fit one coherent objective, prepare a complete Lesson set instead of one broad Lesson.

## Confirm one plan before creating or changing a Lesson

Treat a request to create or revise a Lesson as intent to proceed. Inspect the context, show one
compact plan, and ask for one confirmation before writing. After confirmation, make every approved
change without asking again.

If the user names a deck, assume the Lesson belongs in that deck. Choose the least disruptive topic
and include the placement in the plan. Ask a separate question only when missing information would
materially change the result.

Include:

- target deck and topic, including any locked-topic consequence;
- each proposed Lesson's exact title, one-sentence objective, and estimated duration;
- each proposed Lesson's exact step titles and one short sentence about what each middle step
  teaches;
- a short concept-level coverage summary grouped by Lesson;
- the main example, any meaningful learner action, and the reason for text-only, visual, or
  interactive teaching;
- each image, its source and reuse basis, placement, alias, and alt text;
- each optional library and why the Lesson needs it.

Include any new topic, move, reorder, or deletion in the same plan. Do not show full HTML unless the
user asks to review source. A request to execute an already reviewed plan is confirmation. Show one
revised plan only if the approved scope must change materially.

Lesson and card consent are separate. Do not create cards because a Lesson is created. After a
conversation teaches durable material, offer a Lesson at most once. Do not offer again after the
user declines or asks not to save the material.

## Author within the RecallFox runtime

Before writing or changing step HTML, follow the complete runtime contract in this file. It defines
the iframe sandbox, source format, responsive canvas, color system, accessible interactions, media
bindings, and optional libraries.

Use the exact connected tool schema. Prefer one `create_lesson` call with all steps. Pass
`libraries: []` for a native-only step. For images, also follow the media workflow in the companion
`recallfox` skill.

## Verify before and after a write

Before each create or update call:

1. Run the final instructional quality gate in this file.
2. Run the source preflight in this file.
3. Confirm that the coverage ledger contains every current card id in the deck.
4. Confirm that every proposed image alias has one matching media binding.

After each write:

1. Call `get_lesson`, `list_lessons`, and `list_cards`.
2. Confirm the saved title, objective, step order, step titles, source, libraries, media, and topic.
3. Compare the current deck card ids with the coverage ledger. Resolve every missing id.
4. Run the two gates again against the saved Lesson set.
5. Report what changed and where the learner can find or replay each Lesson.

For an edit, inspect the complete Lesson first. Preserve step identities when changing source.
Reordering must pass every current step id exactly once. Never delete the only step or a step that
holds learner progress.

## MCP tools

- Inspect context: `list_decks`, `list_topics`, `list_cards`.
- Inspect Lessons: `list_lessons`, `get_lesson`.
- Create: `create_lesson`, `add_lesson_step`.
- Revise: `update_lesson`, `update_lesson_step`.
- Organize: `reorder_lesson_steps`, `reorder_lessons`.
- Remove: `delete_lesson_step`, `delete_lesson`.
- Remote media: `import_image_from_url`, `get_media_metadata`, `get_media_image`,
  `authorize_local_image_upload`.
- Local media helper: `inspect_local_image`, `upload_local_image`.

Every create, add, or update step accepts optional `media` bindings. Keep each HTML alias identical
to its binding alias. Lesson tools do not start, complete, skip, or reset learner progress.

## Frame and sandbox

RecallFox wraps each stored step in a generated document. It renders the document in an iframe with
`sandbox="allow-scripts"`. The frame has an opaque origin and no RecallFox account authority.

The content security policy blocks:

- network connections;
- form submission;
- objects and external media;
- external images;
- scripts and styles other than inline code and selected same-origin assets.

Do not use `fetch`, XMLHttpRequest, WebSocket, EventSource, external URLs, cookies, local storage,
navigation, popups, or `parent.postMessage`. Do not collect personal data or imitate trusted
RecallFox prompts.

Store a body fragment only. Do not emit `<!doctype>`, `<html>`, `<head>`, or `<body>`. Inline
`<style>` and `<script>` are allowed. Do not add imports, package URLs, CDN tags, `<script src>`, or
`<link>` tags.

RecallFox injects selected libraries before the fragment. Use the documented browser globals. Pass
each step's exact optional library ids through `libraries`. An empty list is normal.

RecallFox owns progress and navigation outside the frame. The frame does not mark itself complete.
Escape handling is bridged automatically. Do not reproduce Back, Continue, Done, progress, or exit
controls.

RecallFox also sets the active `color-scheme` and injects matching semantic color variables on
`:root`. Do not set, infer, or switch `color-scheme` in Lesson source.

## Responsive full-frame canvas

Design for these dimensions:

- canonical phone viewport: 393 × 852 CSS pixels;
- minimum supported content width: 320 CSS pixels;
- desktop Lesson column: fluid up to 1024 CSS pixels;
- height: the remaining dynamic viewport after RecallFox controls.

Use one outer `.lesson-canvas` and one inner content container. The outer canvas must cover the
complete frame. Apply `max-width` only to the inner container.

The generated document can show a white fallback canvas when the outer canvas does not fill the
frame. Do not use a narrow content card as the outer canvas.

Use this neutral theme-adaptive base:

```html
<section class="lesson-canvas">
  <div class="lesson-content">
    <h2>How a lever changes lifting force</h2>
    <p>Start the teaching content here.</p>
  </div>
</section>
<style>
  * { box-sizing: border-box; }
  html { height: 100%; }
  body {
    min-height: 100%;
    margin: 0;
    display: flex;
    font-family: var(--font-sans);
  }
  .lesson-canvas {
    flex: 1;
    width: 100%;
    min-width: 0;
    background: var(--background);
    color: var(--foreground);
  }
  .lesson-content {
    width: 100%;
    max-width: 42rem;
    margin: 0 auto;
    padding: clamp(20px, 5vw, 32px);
  }
  h2 {
    margin-top: 0;
    font-size: clamp(1.5rem, 6vw, 2.25rem);
    line-height: 1.15;
  }
  p { font-size: 1rem; line-height: 1.6; }
</style>
```

This base needs `libraries: []`.

Use responsive grid or flex wrapping. Let the body scroll vertically. Do not use a fixed desktop
artboard, fixed frame height, or `100vh` inside the frame. Do not hide essential content below a
fixed-height panel.

Prevent horizontal page scrolling at 320 CSS pixels. Use `min-width: 0` on shrinking flex and grid
children. Use `overflow-wrap: anywhere` for learner content that can contain long tokens.

Make SVG and canvas elements responsive. Prefer a responsive SVG `viewBox`. Recalculate
JavaScript-driven dimensions with `ResizeObserver` when needed.

Use body text of at least 16 CSS pixels. Use touch targets of at least 44 × 44 CSS pixels. Use
semantic controls, explicit labels, visible focus states, and non-color feedback. Do not depend on
hover, keyboard-only input, or drag as the only way to complete an action.

## Color contract

Choose one color mode for the complete step.

### Theme-adaptive mode

Use only these matched semantic pairs:

- `--background` with `--foreground`;
- `--card` with `--card-foreground`;
- `--primary` with `--primary-foreground`;
- `--secondary` with `--secondary-foreground`;
- `--muted` with `--muted-foreground`;
- `--accent` with `--accent-foreground`;
- `--destructive` with `--destructive-foreground`.

Use `--border`, `--input`, and `--ring` for their named roles. RecallFox always injects these values
for the active scheme. Do not add fixed fallback colors to semantic variable calls.

### Custom palette exception

Ignore or override RecallFox colors only when custom colors make the Lesson easier to understand or
follow a meaningful domain convention.

Examples include:

- a blue-to-red scale that explains temperature;
- standard atom colors in a molecule;
- distinct path colors that help compare routes.

Use this exception for teaching, not decoration or branding. Set a readable fixed foreground each
time you set a fixed background. Add labels, patterns, positions, or shapes so color is not the only
signal.

### Pairing and contrast

Do not mix a fixed color with a theme-variable mate. When an element sets a non-transparent
background, set its foreground in the same CSS rule. Do not depend on inherited text color across a
background change.

Maintain WCAG AA contrast. Preserve visible focus and state changes without color-only meaning.
Figtree is available as `var(--font-sans)`. IBM Plex Mono is available as `var(--font-mono)`.

## Interaction implementation

Select the control from the teaching model:

- Use a range slider for a continuous quantity or many meaningful values.
- Use labelled buttons, a segmented control, tabs, or Previous and Next for two to four states.
- If discrete slider stops are the clearest model, label each stop, snap exactly, and add buttons.

Make clickability visible before use. Give controls a resting shape, border, or fill. Add hover,
`:focus-visible`, pressed or selected, and disabled states. Use `cursor: pointer` for enabled pointer
controls.

Put a short action hint next to each meaningful interaction. Use text such as `Tap a stage`,
`Drag the marker or use the arrow buttons`, `Choose an outcome`, or `Check the factors`. Prefer
`Tap` over `Click` for controls that also work on phones.

Do not hide the primary instruction in a tooltip. An info control can contain optional detail. It
must open through tap and keyboard activation as well as hover or focus. Give the control an
accessible name and a 44 × 44 CSS-pixel target.

This native pattern provides optional interaction help without JavaScript:

```html
<div class="interaction-head">
  <p class="action-hint"><span aria-hidden="true">☝</span> Tap a stage to compare.</p>
  <details class="help">
    <summary aria-label="How to use this interaction">i</summary>
    <div class="help-pop">Tap a labelled stage. With a keyboard, use Tab and Enter.</div>
  </details>
</div>
<style>
  .interaction-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
  }
  .action-hint {
    margin: 0;
    color: var(--muted-foreground);
    font-weight: 700;
  }
  .interaction-head button, .help summary { cursor: pointer; }
  .interaction-head button {
    transition: background-color .15s ease, transform .15s ease, box-shadow .15s ease;
  }
  .interaction-head button:hover {
    background: var(--secondary);
    color: var(--secondary-foreground);
  }
  .interaction-head button:active { transform: translateY(1px); }
  .interaction-head button:focus-visible, .help summary:focus-visible {
    outline: 3px solid var(--ring);
    outline-offset: 2px;
  }
  .help { position: relative; flex: 0 0 auto; }
  .help summary {
    display: grid;
    place-items: center;
    width: 44px;
    height: 44px;
    list-style: none;
    border: 2px solid var(--border);
    border-radius: 50%;
  }
  .help summary::-webkit-details-marker { display: none; }
  .help-pop {
    display: none;
    position: absolute;
    z-index: 5;
    right: 0;
    top: 50px;
    width: min(16rem, calc(100vw - 3.5rem));
    padding: 12px;
    border-radius: 10px;
    background: var(--primary);
    color: var(--primary-foreground);
    box-shadow: 0 8px 22px color-mix(in srgb, var(--foreground) 20%, transparent);
  }
  .help[open] .help-pop,
  .help:hover .help-pop,
  .help:focus-within .help-pop { display: block; }
  @media (hover: none) {
    .help:not([open]) .help-pop { display: none; }
  }
  @media (prefers-reduced-motion: reduce) {
    .interaction-head button { transition: none; }
  }
</style>
```

After interaction, update `aria-pressed` or `aria-selected` when applicable. Put dynamic
explanations in an appropriate `aria-live` region. Keep the current explanation visible until the
learner changes state.

When animation explains a sequence, provide learner control. For a multi-state explanation, include
Previous and Next. Add Pause during automatic playback and Replay after it finishes. Respect
`prefers-reduced-motion`. Do not make the learner race transient text.

## Images and media bindings

Use an image only when seeing the subject teaches appearance, structure, spatial relationships,
change, or context better than words alone. Do not use decorative or redundant images.

Include the source, reuse basis, placement, alias, and alt text in the Lesson proposal. Follow the
companion `recallfox` skill:

1. Import a reviewed public HTTPS image with `import_image_from_url`, or use the approved local
   one-use upload flow.
2. Call `get_media_image` before binding the result.
3. Choose a lowercase hyphenated alias.
4. Bind the owned asset to the exact step.

Reference an asset only with this form:

```html
<img data-rf-media-alias="packet-flow" alt="Packet moving through three network hops">
```

Pass the matching binding on that step:

```json
{"media": [{"alias": "packet-flow", "asset_id": "..."}]}
```

Do not add `src` with an online, API, or storage URL. Do not fetch an image from step JavaScript.
RecallFox injects private bytes into the existing image and opens it in an expanded viewer when the
learner selects it. RecallFox does not size the image. Author its layout with normal CSS:

```css
img { display: block; max-width: 100%; height: auto; }
```

Images in the frame must resolve to `data:` or `blob:` values.

## Optional library catalog

These exact globals were checked against npm on 2026-08-06. They are the newest stable releases old
enough to pass RecallFox's 21-day dependency quarantine. A newer npm tag can exist. Every library is
optional and selected independently per step.

The snippets below demonstrate each browser global. They are not complete Lesson steps. Apply every
responsive, color, interaction, and accessibility rule in this file around them.

### `alpine` — Alpine.js 3.15.12 (`Alpine`)

Use for small declarative state, input binding, conditional explanations, and repeated markup.
[Official start guide](https://alpinejs.dev/start-here).

```html
<div x-data="{ packets: 1 }">
  <label for="packet-count">Packets: <output x-text="packets"></output></label>
  <input id="packet-count" type="range" min="1" max="5" x-model.number="packets">
</div>
```

### `motion` — Motion 12.42.2 (`Motion`)

Use for an explanatory transition, path, sequence, or replayable state change.
[Official quick start](https://motion.dev/docs/quick-start).

```html
<button id="send">Send packet</button>
<div id="packet" aria-label="Packet"></div>
<script>
  const { animate } = Motion;
  const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;
  document.querySelector('#send').addEventListener('click', () => {
    animate('#packet', { x: [0, 220], opacity: [1, 1, 0] },
      { duration: reduceMotion ? 0 : 1.2 });
  });
</script>
```

### `interact` — interact.js 1.10.27 (`interact`)

Use for drag, resize, drop-zone, or gesture models. Always provide tap, button, and keyboard
alternatives. [Official draggable guide](https://interactjs.io/docs/draggable/).

```html
<div class="token" tabindex="0" role="img" aria-label="Packet">Packet</div>
<button id="move-left">Move left</button>
<button id="move-right">Move right</button>
<p id="token-status" aria-live="polite">Packet position: 0.</p>
<style>.token { touch-action: none; user-select: none; }</style>
<script>
  const position = { x: 0, y: 0 };
  const token = document.querySelector('.token');
  const status = document.querySelector('#token-status');
  function render() {
    token.style.transform = 'translate(' + position.x + 'px, ' + position.y + 'px)';
    status.textContent = 'Packet position: ' + position.x + '.';
  }
  interact('.token').draggable({ listeners: { move(event) {
    position.x += event.dx;
    position.y += event.dy;
    render();
  } } });
  document.querySelector('#move-left').onclick = () => { position.x -= 20; render(); };
  document.querySelector('#move-right').onclick = () => { position.x += 20; render(); };
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
`viewBox` SVG. [Official getting-started guide](https://d3js.org/getting-started).

```html
<svg id="chart" viewBox="0 0 320 120" role="img" aria-label="Latency by hop"></svg>
<script>
  const values = [18, 42, 61, 85];
  d3.select('#chart').selectAll('rect').data(values).join('rect')
    .attr('x', (_, i) => i * 76).attr('y', d => 110 - d)
    .attr('width', 56).attr('height', d => d).attr('fill', 'var(--primary)');
</script>
```

### `cytoscape` — Cytoscape.js 3.34.0 (`cytoscape`)

Use for networks, dependency graphs, state graphs, and paths the learner should inspect or change.
Give the container a responsive height. [Official API and examples](https://js.cytoscape.org/).

```html
<div id="graph" role="img" aria-label="Client sends a request to a server"
  style="height:320px"></div>
<script>
  const cy = cytoscape({
    container: document.querySelector('#graph'),
    elements: [
      { data: { id: 'client' } },
      { data: { id: 'server' } },
      { data: { id: 'request', source: 'client', target: 'server' } }
    ],
    layout: { name: 'grid', rows: 1 }
  });
</script>
```

### `p5` — p5.js 2.3.0 (`p5`)

Use for dynamic canvas simulations, geometry, physics, procedural models, or continuous input. Use
instance mode to prevent global-name collisions. [Official reference](https://p5js.org/reference/).

```html
<label for="position">Position: <output id="position-value">5</output></label>
<input id="position" type="range" min="0" max="10" value="5">
<div id="sketch"></div>
<script>
  const rootStyle = getComputedStyle(document.documentElement);
  const background = rootStyle.getPropertyValue('--background').trim();
  const foreground = rootStyle.getPropertyValue('--foreground').trim();
  const position = document.querySelector('#position');
  const positionValue = document.querySelector('#position-value');
  const sketch = document.querySelector('#sketch');
  new p5(p => {
    p.setup = () => {
      p.createCanvas(sketch.clientWidth, 180).parent(sketch);
      new ResizeObserver(() => p.resizeCanvas(sketch.clientWidth, 180)).observe(sketch);
    };
    p.draw = () => {
      p.background(background);
      p.fill(foreground);
      p.circle(20 + Number(position.value) * (p.width - 40) / 10, 90, 24);
      positionValue.value = position.value;
    };
  });
</script>
```

### `mermaid` — Mermaid 11.16.0 (`mermaid`)

Use for a flowchart, sequence, state, or relationship diagram. Initialize explicitly and keep strict
security. [Official usage guide](https://mermaid.js.org/config/usage.html).

```html
<pre class="diagram">sequenceDiagram
  Client->>Server: GET /resource
  Server-->>Client: 200 OK</pre>
<script>
  const theme = getComputedStyle(document.documentElement);
  const color = name => theme.getPropertyValue(name).trim();
  mermaid.initialize({
    startOnLoad: false,
    securityLevel: 'strict',
    theme: 'base',
    themeVariables: {
      background: color('--background'),
      primaryColor: color('--card'),
      primaryTextColor: color('--card-foreground'),
      lineColor: color('--foreground'),
      textColor: color('--foreground')
    }
  });
  mermaid.run({ nodes: document.querySelectorAll('.diagram') });
</script>
```

### Selection guide

| Teaching need | Prefer |
| --- | --- |
| Simple values, toggles, or branching text | Native JavaScript or `alpine` |
| Purposeful motion or a replayable transition | `motion` |
| Drag, drop, resize, or direct manipulation | `interact` |
| Typeset mathematics | `katex` |
| Data-driven SVG or charts | `d3` |
| Interactive node and edge networks | `cytoscape` |
| Continuous visual simulation or canvas sketch | `p5` |
| Flow, sequence, state, or relationship diagram | `mermaid` |

Do not select a library because it is available. Native code plus one focused library is usually
more reliable on a phone.

## Source preflight

Do this source-level check before every create or update call:

1. The source is a body fragment with no imports or external URLs.
2. One outer canvas covers the complete frame. Only inner content has a maximum width.
3. The layout can shrink to 320 CSS pixels and scroll vertically.
4. The step uses one color mode.
5. Every non-transparent background has its matched foreground in the same rule.
6. Controls are semantic, labelled, visible before use, keyboard accessible, and at least 44 × 44.
7. State and feedback do not depend on hover, drag, motion, or color alone.
8. Every listed library is used, and every used library is listed.
9. Every media alias has one exact binding and useful alt text.
10. The source contains no RecallFox navigation or progress controls.

This preflight does not require visual QA, a screenshot, or a visual-capable model.

## Instructional and language quality rules

Meet every unconditional rule in this section. Apply a conditional technique only when its stated
condition is present. Do not add a visual, interaction, or question only to satisfy a checklist.

### Backward Design

State what the learner should understand or be able to do after the Lesson. Design every
explanation, example, action, and feedback message backward from that outcome. Remove content that
does not help the learner reach the outcome.

### Bloom's Revised Taxonomy

Choose one suitable cognitive process: remember, understand, apply, analyze, evaluate, or create.
Teach and demonstrate the cognitive process named by the objective.

- For **understand**, explain the mechanism or distinction with a concrete case.
- For **apply**, show a complete example, then let the learner apply the same rule with support.
- For **analyze**, model how to compare parts, evidence, or causes before asking for a comparison.
- For **evaluate**, state the criteria and model one judgment before asking for a judgment.
- For **create**, show a model and constraints before asking the learner to produce something.

Do not use an objective such as “apply” when the Lesson only gives definitions. Do not require a
higher level than the Lesson teaches.

### Private deck-wide card coverage and prior knowledge

Every card in the target deck is mandatory teaching scope. Do not omit a card because it is
difficult, repetitive, in a locked topic, or inconvenient for the current Lesson.

Cards define the minimum knowledge scope, not the maximum. Add relevant prerequisites, mechanisms,
connections, context, or transfer examples when they make the required knowledge easier to
understand or use. Do not add unrelated facts or a second objective.

Create a literal private coverage-ledger row for every card:

`card id → topic → required knowledge → Lesson → step → teaching treatment`

The ledger is an internal authoring and verification control. It does not determine or limit the
number of Lessons in a topic. A topic can contain as many focused Lessons as its coherent objectives
require.

Keep the ledger private by default. In the confirmation plan, show only the concept-level coverage
summary. Do not expose card ids, ledger rows, internal coverage status, or the phrase `coverage
ledger` unless the user explicitly requests an authoring audit. Never place them in deck or topic
metadata, Lesson titles or descriptions, or learner-facing step content.

A card is covered only when Lesson content teaches all educational information needed to understand
and answer it. This includes important conditions, reasoning, distinctions, and explanations from
the card. A title, passing mention, copied prompt, or isolated definition does not count.

- Give every card id a non-empty Lesson, step, and teaching treatment.
- Map the card to an explanation plus a concrete example, demonstration, comparison, or application.
- Cards that test the same knowledge can share one teaching treatment. Keep every card id in the
  ledger so none disappear during grouping.
- Credit an existing Lesson only after `get_lesson` confirms that its saved steps teach the card's
  complete required knowledge. Record its Lesson and step in the ledger.
- When an earlier Lesson covers a card or prerequisite well, build on it with a short connection.
  Do not repeat the full teaching without a reason.
- When earlier teaching is partial, teach the missing part before using it. When a prerequisite
  needs its own objective, place it in an earlier Lesson.
- Cover the knowledge, not the card wording. Do not turn card prompts into Lesson questions.
- If one coherent Lesson cannot cover the deck, create a Lesson set. The complete set must cover
  every ledger row.
- Place each Lesson in the suitable topic. Respect topic order and locked-topic access.
- Assume only knowledge confirmed in earlier saved Lessons. Topic placement or a Lesson title does
  not prove that the learner received the required teaching.
- If a card appears incorrect, conflicting, or duplicated, flag it in the plan. Do not silently skip
  it or teach information known to be incorrect.

Do not claim that deck authoring is complete while any current card id lacks saved teaching content.

### One coherent objective

Teach one coherent objective per Lesson. Use at least three steps so the opening, teaching, and
recap stay separate. Aim for about five to ten minutes, but let the idea determine the duration.

Split the Lesson when the objective joins independent skills or mechanisms. A catalogue of terms is
not a coherent objective. Depth is more important than the number of concepts mentioned.

### Clear Lesson purpose

Give the Lesson a literal title that states the subject and useful outcome. Do not use a teaser,
metaphor, or clever title that hides what the Lesson teaches.

### First step: What you will learn

The first step must orient the learner before teaching starts.

- Use the title `What you will learn about [specific subject]`.
- State the objective in one short sentence.
- Give a compact summary of the path through the Lesson. Use two to four short lines when useful.
- Name only ideas that the Lesson teaches.
- Do not teach details, ask a question, or require an interaction.

If the summary becomes a long list of independent ideas, split the Lesson.

### Middle steps: Teach and support

Put all new teaching and learner participation in the middle steps. Each middle step must answer one
clear learner question. A central teaching step must do more than show a term and its definition.

For each central concept:

1. Start with a concrete, self-contained case.
2. Show the relevant observation, change, or decision.
3. Explain why the result occurs.
4. State the usable rule, boundary, or decision method.
5. Contrast a near-miss when learners commonly confuse two ideas.

These parts can share a step when the concept is simple. Separate them when combining them would
increase cognitive load.

### Last step: What you learned

The last step must summarize the completed Lesson.

- Use the title `What you learned about [specific subject]`.
- Restate the outcome.
- Recap the key ideas in concise language.
- Do not add a concept, example, question, or required interaction.

### Clear step titles

Give every step a plain title that states the exact concept, relationship, or action taught there.
The stored title and visible heading must communicate the same idea. The title must make sense
outside the Lesson.

Do not use vague titles such as `Explore`, `Try it`, `What happens next?`, or
`Notice what receives too much weight`.

Use a subject-specific title instead:

- `How sunlight warms Earth's surface`
- `Why condensation forms on a cold glass`
- `Use unit price to compare package sizes`

If a title lists independent concepts with commas or several uses of “and,” inspect the scope.
Split the step unless the title names one real relationship.

### Cognitive Load Theory (CLT)

Keep working-memory demands manageable.

- **Segmenting Principle:** Teach one complex concept or reasoning move at a time. Add steps when
  the learner needs more segmentation.
- **Coherence Principle:** Remove decorative content and controls that do not support the objective.
- Reveal optional detail after the core explanation.
- Split the Lesson when the added steps no longer serve one objective.

Do not compress several definitions into cards or columns and call that teaching.

### Concrete example quality

Every central concept needs a concrete teaching example unless the concept is already a concrete
demonstration. A definition alone is not sufficient.

A strong example:

- includes all facts the learner needs;
- uses a familiar or quickly explained context;
- changes only the details that matter to the concept;
- shows the reasoning, not only the final answer;
- explains why each important detail matters;
- ends with a conclusion the learner can use elsewhere.

Use exact values, labels, or events when they make the reasoning visible. Avoid niche cultural
knowledge unless the Lesson explains it. When transfer matters, follow the first example with a
second case that has the same structure and different surface details.

### Worked Example Effect

For an unfamiliar procedure or reasoning process, show one complete worked example before asking
the learner to perform the process.

Show the goal, starting information, each decision or step, the reason for each step, and the final
interpretation. Do not skip the difficult inference. Keep each explanation close to the part it
explains.

### Scaffolding and Guidance Fading

Scaffolding gives temporary support while the learner develops the skill. After the worked example,
give the learner a similar case with one meaningful part to complete. Provide a cue, partial
solution, constrained choice, or visible rule. Give immediate explanatory feedback.

If the Lesson includes another application, reduce support gradually. Do not remove support before
the learner has seen the complete reasoning.

### Visual teaching models and interaction

Treat words, visuals, and learner control as one teaching model. First identify the relationship the
learner must see. Then decide whether the model should be static or interactive.

Use a visual when the concept depends on:

- structure or containment;
- sequence or flow;
- comparison between states;
- scale, quantity, or proportion;
- change over time.

Use a static visual when the complete relationship is clear at one glance. Add interaction when
learner control makes changing, comparing, sequencing, inspecting, or applying the model easier to
understand.

Examples include:

- a temperature slider that updates a number line and a state label;
- a serving-count slider that updates ingredient quantities and proportional bars;
- Before and After buttons that update the same diagram to show a transformation;
- Previous and Next buttons that highlight stages in one timeline;
- ordering controls that move process stages and give immediate explanatory feedback.

Choose controls from the model:

- Use a slider for a continuous quantity or many meaningful values.
- Use labelled buttons, tabs, or Previous and Next controls for two to four discrete states.
- Keep the same visual model across interactive states.
- Make the control change the visual, evidence, highlighted relationship, or explanation.
- Give immediate feedback that explains the result.
- Provide a non-drag alternative when drag is available.

A row of cards, columns, badges, or arrows is not automatically a meaningful visual. Position,
size, containment, connection, or movement must communicate part of the concept.

Apply **Dual Coding and Multimedia Learning** by pairing words with a visual only when both
representations improve understanding.

- **Signaling Principle:** Use headings, labels, and visual cues to show the essential structure.
- **Spatial Contiguity Principle:** Put labels and explanations next to the visual parts they
  describe.

Include a text equivalent. Keep visuals relevant and non-redundant. Use more than color to
communicate meaning. Use motion when it explains sequence or change.

Choose the simplest format that teaches the relationship clearly. Text, a worked example, a table,
a static visual, or an interactive model can each be correct. A visual or interaction is not
mandatory.

A control that only reveals hidden prose is weak interaction. Prefer controls that help the learner
inspect or act on the teaching model.

If the objective uses apply, analyze, evaluate, or create, include at least one supported learner
action in a middle step. The action can be a short choice, comparison, calculation, ordering task,
or learner-controlled model. It does not need elaborate controls or animation.

### Questions and Retrieval Practice

Questions are teaching tools, not the retrieval system. RecallFox cards own Retrieval Practice and
long-term recall.

Use at most one or two lightweight questions in a Lesson. Use a question only for a complex,
counterintuitive, or commonly misunderstood idea. Use the response to expose the misconception and
give immediate explanatory feedback. Do not ask the learner to repeat a fact that the prior step
just stated. A Lesson can contain no question.

### ASD-STE100 (Simplified Technical English)

Use adapted ASD-STE100 as a required standard for all learner-facing text.

- Use no more than 20 words in an instruction.
- Use no more than 25 words in a descriptive sentence.
- Put only one instruction in a sentence unless two actions must occur at the same time.
- Put one main idea in each sentence.
- Put one topic in each paragraph. Use no more than six sentences in one paragraph.
- Prefer a clear subject, verb, and object.
- Use one term for each concept. Do not change terms only for variety.
- Name the subject again when `it`, `this`, `that`, `they`, or `which` could be ambiguous.
- Use common words. Define a necessary domain term on first use.
- Expand an uncommon abbreviation on first use.
- Prefer active voice when the actor matters.
- Do not use idioms, slang, unnecessary synonyms, double negatives, or dense noun strings.
- Use literal headings and control labels.

Do not enforce the approved STE vocabulary when a domain term, accurate analogy, or natural
educational phrase is clearer. Accuracy and clarity take precedence over mechanical compliance.

Before writing, read every learner-facing sentence again. Split dense sentences. Remove vague
references. Replace inconsistent terms.

### Feedback and learner respect

- Give immediate feedback that explains the cause, rule, or next reasoning step.
- Do not use scores, streaks, countdowns, repeated drills, or claims that completion proves mastery.
- Do not describe a concept as “easy,” “simple,” or “obvious.”
- Keep each step useful when the learner replays it by itself.
- Let RecallFox own Back, Continue, Done, progress, persistence, and exit controls.
- Prefer native HTML, CSS, and JavaScript. Select a library only when it improves the teaching
  model or makes the implementation more reliable.

### Example of a focused Lesson plan

Copy the teaching pattern, not the topic or step count.

One focused Lesson can teach how to scale ingredient amounts for a different number of servings.

Objective: Use a scale factor to calculate a new ingredient amount.

1. `What you will learn about scaling a recipe`
2. `Find the scale factor from the serving counts`
3. `Scale two cups of rice from four servings to six`
4. `Use the scale factor for another ingredient`
5. `What you learned about scaling a recipe`

Step 3 gives the complete example. The scale factor is `6 ÷ 4 = 1.5`. Two cups multiplied by `1.5`
gives three cups. Step 4 keeps the method visible while the learner scales another ingredient and
receives explanatory feedback.

This example uses five steps. Do not force every Lesson into five steps. Use the deck's cards,
prerequisite needs, and cognitive load to choose the step count. Use at least three steps for the
required opening, teaching, and recap. Create more steps or more Lessons when the required knowledge
needs them.

### Final instructional quality gate

Do not create or update the Lesson until every answer is yes:

1. Does the Lesson have one clear outcome at the level it teaches?
2. Does the private, literal coverage ledger include every current card id in the target deck?
3. Is the ledger absent from default user-facing and learner-facing content?
4. Does every card map to saved content that teaches all its required information?
5. Does each treatment include more than a title, mention, copied prompt, or isolated definition?
6. Does Lesson count follow coherent objectives and cognitive load instead of topic count?
7. Is prior knowledge based on the saved content of actual earlier Lessons?
8. Are missing prerequisites taught before the Lesson uses them?
9. Does added content support card knowledge, prerequisites, or transfer without adding another
   objective?
10. Can a learner with only the confirmed prior knowledge follow the Lesson?
11. Are the first and last steps orientation and recap steps with the required titles?
12. Does every middle title state exactly what that step teaches?
13. Does every central concept have a concrete example and an explanation of why?
14. Does the Lesson model every reasoning process before asking the learner to use it?
15. Does an apply, analyze, evaluate, or create objective include a supported learner action?
16. Does each learner action support the objective and receive explanatory feedback?
17. Was text-only, visual, or interactive teaching chosen for a clear teaching reason?
18. When the concept depends on structure, sequence, containment, flow, scale, or change, does a
    meaningful visual encode that relationship?
19. Does each interaction change or support the teaching model instead of only revealing prose?
20. Does every visual, interaction, and question have a clear teaching purpose?
21. Does all learner-facing text pass the adapted ASD-STE100 rules?
