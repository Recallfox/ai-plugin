---
name: recallfox
description: Capture and organize durable knowledge in recallfox using decks, topics, Learning Paths, interactive Lessons, and spaced-repetition cards. Use when the user asks to remember something, make cards or Lessons, organize or inspect their learning, says "add this to recallfox" or "recall this", or finishes learning durable material that may be worth retaining.
---

# recallfox

recallfox is a spaced-repetition retention layer. Use its MCP tools to turn a small number of
durable ideas into atomic cards and place them coherently in the user's existing learning structure.
The user authorizes the connector once; every tool is scoped to their account.

## Consent boundary

- Never create cards silently. Show the proposed cards and placement, then create only what the user
  accepts. An explicit request to create specific cards is consent for those cards, but not for
  unrelated restructuring.
- Never create a Lesson silently. An explicit request to create a specified Lesson is consent for
  that Lesson; otherwise offer it once and wait. Lesson and card consent are independent.
- Ask before changing an existing deck's name, emoji, or description.
- Ask before creating, renaming, deleting, splitting, or reordering topics; moving existing cards;
  disabling an existing Learning Path; changing an existing path's threshold; or unlocking a topic
  early. Enabling progressive disclosure may be proactive under the guidance below.
- A single combined proposal is enough: show the target deck/topic, cards, and any structural change
  together. Do not make the user approve every tool call separately.
- Zero cards is a valid result. Skip filler, trivia, and conversation-specific details.

## Understand the structure before writing

For an existing library, inspect before proposing:

1. `list_decks`: compare deck purpose, card/learned counts, retention, whether sequencing is enabled,
   and its unlock threshold. Reuse a cohesive deck instead of creating a near-duplicate.
2. `list_topics` on likely decks: inspect names, descriptions, order, card/learned counts, required
   count, status, and `is_unlocked`.
3. `list_cards` in likely decks/topics, using search where useful: avoid duplicates and understand
   the level and vocabulary already present.

recallfox currently organizes authored notes through decks and exactly one topic per note. It does
not expose tags through this connector. Do not invent tag state or claim to have inspected tags.

## Decide where new knowledge belongs

Prefer the least structural change that keeps the library coherent:

1. Reuse a relevant existing topic when the knowledge extends it naturally.
2. Use the first/default topic (often **General**) for a small capture that does not justify a new
   stage. Topics are optional as a user-facing organization choice even though every note has a
   fallback topic internally.
3. Propose a new topic inside an existing deck when the material forms a distinct concept or stage
   with enough substance to grow. Give it a short description of what someone will learn.
4. Propose a new deck only when no existing deck is a cohesive home. A deck should remain a coherent
   study unit, not a catch-all folder.

Topic size is a working heuristic, not a database limit. Aim for a focused topic of roughly 10–25
cards. When a topic would grow beyond about 25 good cards, inspect its contents and propose a split
only if there is a clear conceptual seam. Never manufacture topics merely to satisfy a number.

For a large capture, propose topic grouping and order before creating cards. For one or two durable
ideas, General or an existing topic is usually better than new structure.

## Offer a Lesson when teaching would help

Cards retain knowledge after it has become understandable. A Lesson can first make a new mechanism,
flow, or distinction understandable through examples and optional interaction.

- When the user has just learned durable new material, and a replayable teaching experience would
  genuinely help, offer one concise next step: “I can also add a short interactive Lesson to
  **<topic>** so you can explore it now and replay it from the Learning Path later. Want me to create
  it?” Then wait.
- Do not offer for a trivial fact, a simple storage request, material the user already knows, or after
  the user declines or explicitly asks not to save it.
- Reuse the least-disruptive topic. If a new topic is warranted, include it in the same proposal and
  obtain confirmation before creating it.
- If the user requests or accepts a Lesson, use the companion `author-lessons` skill. It owns lesson
  pedagogy, sandbox HTML, responsive design, optional libraries, and the Lesson MCP workflow.

## Respect Learning Path access

- Evaluate whether progressive disclosure fits the deck instead of waiting for the user to raise it.
  It usually makes sense when the deck has more than three meaningful topics or roughly 30–40
  cards, especially when later material depends on earlier material. Treat these as heuristics, not
  hard cutoffs; use the topic structure, card relationships, and likely study burden to decide.
- When progressive disclosure clearly helps, enable it without requiring advance confirmation.
  Explain the reasoning and resulting access changes afterward, then ask whether the user would
  prefer it disabled or configured differently. When it does not help, leave it disabled, explain
  why, and ask whether the user wants to enable it anyway.
- Topic order gates only the introduction of **new** cards. Started and due cards keep their FSRS
  schedules and remain accessible.
- If the chosen topic is locked, tell the user the new cards will wait until that topic unlocks. Do
  not silently use `study_ahead` to bypass the path.
- `reorder_topics` changes future introduction order but preserves schedules and ordinary unlock
  history. Always pass every topic id exactly once.
- `configure_learning_path` is an access rebase that may change which unseen topics are locked under
  the current order/progress. Proactive enabling is allowed under the heuristic above; get explicit
  consent before disabling an existing path or changing its existing threshold.
- Retention describes successful learned-card reviews; it is useful context, not proof that a topic
  is mastered and not a reason by itself to reorganize the deck.
- `assign_cards_to_topic` and `move_cards_to_deck` are organizational: card schedules, progress, and
  review history are preserved.

After creating or reorganizing structured material, call `list_topics` again and report the resulting
order, progress, and locked/unlocked state. If the result differs from the proposal, say so.

## Author high-quality cards

Before choosing a card type:

- Capture one durable idea per card. Give the front enough context to remain clear months later and
  keep the answer to the smallest sufficient explanation.
- Prefer retrieval over recognition. If the learner should produce or explain the answer unaided,
  use Basic rather than turning it into an easier Options card.
- Skip trivia, filler, duplicates, and details useful only in the current conversation. Prefer 5
  sharp cards over 20 padded ones.
- In a batch, vary phrasing and answer positions without changing the knowledge being tested.

## Choose the right card type

Choose the retrieval behavior first; card type is part of card quality, not a formatting choice.
Name the proposed type so the user can judge it.

- **Basic — produce the answer unaided:** use for explanations, definitions, causes, procedures,
  commands, and ordinary question-answer knowledge. This is the default when direct recall is the
  real skill.
- **Cloze — complete meaningful context:** use when recalling an exact word or short phrase inside a
  sentence provides a useful cue. Hide answers in `[[double brackets]]`; do not use cloze merely to
  turn a list into many weak cards.
- **Options — discriminate among plausible alternatives:** use for classification, diagnosis,
  commonly confused concepts, or a naturally closed set where choosing the right alternative is
  itself transferable knowledge. Options are not an easier version of a Basic card.

### Basic card quality

- Ask for one specific fact, explanation, cause, or procedure. Split compound questions into cards.
- Include the subject, scope, and conditions needed to answer without the original conversation.
- Avoid vague fronts such as “Explain this” and prompts broad enough to accept many answers.
- Make the back direct and minimal, but include the key reason or distinction when it prevents confusion.
- Create a reversed card only when recalling the relationship in both directions is independently useful.

### Cloze card quality

- Write a self-contained, natural sentence whose meaning remains clear with the answer hidden.
- Hide the smallest meaningful word or phrase; do not test trivial grammar or blank most of a sentence.
- Ensure the context permits one intended answer and does not reveal it through repetition or grammar.
- Use multiple blanks only when the items form one meaningful unit; otherwise split them into cards.
- When editing, preserve blank count and order if changing them could misattribute review history.

### Options card quality

- Use Options only when distinguishing plausible alternatives is the learning objective. Definitions
  and explanations normally belong in Basic cards.
- Make the question answerable before reading the choices. Include the facts or decision criterion
  needed to resolve words such as “best,” “usually,” or “most appropriate.”
- Prefer three or four choices. Draw every choice from the same conceptual category and keep grammar,
  length, tone, and specificity parallel.
- Make each distractor a realistic misconception or near-neighbor concept. Require at least two
  plausible distractors; otherwise use Basic.
- Reject a card if the answer is exposed by being the only serious, precise, long, or grammatically
  matching option. Avoid absurd choices, invented facts, overlaps, and “all/none of the above.”
- Across a batch, distribute the correct option positions; do not create a predictable answer pattern.
- Require exactly one unambiguously correct answer under the stated scenario.
- Put the question on `front`, complete answer choices in `options`, and the zero-based authored-list
  answer index in `correct_option`. Use `back` to explain why the answer is correct and, when useful,
  why the closest distractor is wrong; do not merely repeat the correct option.
- In the proposal, show every choice, mark the correct answer, and include the explanation. Do not
  hide the answer from the user during authoring review.

### Examples are illustrative, not templates

Copy the quality standard, not the topic, wording, length, or structure. Questions may be shorter;
answers and Options choices may be a phrase or one word when that is sufficient.

- **Basic** — Front: “Why can a metal spoon feel colder than a wooden spoon in the same room?”
  Back: “Metal transfers heat away from your hand faster; the spoons may be the same temperature.”
- **Cloze** — “Plants convert light energy into chemical energy through [[photosynthesis]].”
- **Options** — Front: “Which planet has the shortest year?” Options: “Mercury” **(correct)**,
  “Venus,” “Earth,” “Mars.” Back: “Mercury completes an orbit in about 88 Earth days.”
- **Options, scenario-based** — Front: “Bread dough stays dense after adequate kneading. The yeast
  was mixed with near-boiling water and produced no bubbles. What is the most likely cause?” Options:
  “The yeast was killed by excessive heat” **(correct)**, “The gluten network was underdeveloped,”
  “Fermentation was slowed by a cold environment,” “The flour absorbed too little water.” Back:
  “Near-boiling water can kill yeast, preventing the gas production needed for the dough to rise.”

## Default capture workflow

1. Inspect relevant decks, topics, access state, and existing cards.
2. Draft a selective shortlist and apply the matching quality gate. Rewrite unclear Basic or Cloze
   cards; convert weak Options cards to Basic instead of padding them with obvious distractors.
3. Choose the least-disruptive placement and, when needed, a proposed topic split/order.
4. Show the user the cards, target placement, and access consequence (for example, “this topic is
   locked, so these new cards will wait”). Ask for one confirmation.
5. Apply only the accepted card and structural changes.
6. Re-read topics and summarize what changed, including resulting lock state.
7. If this was a learning conversation and an interactive explanation would add real value, make the
   single optional Lesson offer described above. Do not create it in the card write without consent.

## Add images only when they teach

- Use an image when spatial structure, a diagram, an artifact, or a visual comparison materially
  improves learning. Do not decorate cards or Lessons with unrelated images.
- Before importing an online image, inspect the actual image and its source page. Confirm that the
  user accepts the source and has a valid reuse basis. Never treat a search thumbnail as the source.
- For an online image, call `import_image_from_url` with the original public HTTPS image URL. The
  remote server downloads, validates, normalizes, and stores it privately. Call `get_media_image`
  on the returned asset and verify that the stored normalized image is the intended one.
- For a local image, call local `inspect_local_image`. Pass its filename, size, and SHA-256 to remote
  `authorize_local_image_upload`. Then call local `upload_local_image` with the same path and the
  returned one-use token. Never quote, log, or reuse the token.
- If the local media tool is unavailable, explain that local automatic upload needs Node.js and the
  plugin's `recallfox-media` MCP server. Do not claim that remote MCP can read a local path.
- Choose a lowercase hyphenated alias. Bind the returned asset using `{alias, asset_id}` in the card
  or Lesson write. An alias is local to that note or Lesson step.
- Place card images with `![useful alt text](rf-media-alias:alias)`. Place Lesson images with
  `<img data-rf-media-alias="alias" alt="useful alt text">`. The reference and binding aliases must
  match exactly. Never put asset ids, S3 paths, or external image URLs in authored content.
- Include the image, placement, alias, and alt text in the same consent proposal as the content.
  Read the saved content back and verify that every reference has a binding.

## MCP tools

- Inspect: `list_decks`, `list_topics`, `list_cards`.
- Create: `create_deck`, `create_topic`, `create_basic_card`, `create_cloze_card`,
  `create_choice_card`.
- Organize decks and paths: `update_deck`, `update_topic`, `delete_topic`, `reorder_topics`,
  `configure_learning_path`, `study_ahead`.
- Organize cards: `assign_cards_to_topic`, `move_cards_to_deck`.
- Maintain cards: `update_basic_card`, `update_cloze_card`, `delete_card`.
- Lessons: `list_lessons`, `get_lesson`, `create_lesson`, `update_lesson`, `add_lesson_step`,
  `update_lesson_step`, `reorder_lesson_steps`, `delete_lesson_step`, `reorder_lessons`,
  `delete_lesson`. Follow the companion authoring skill before using Lesson write tools.
- Media, remote: `import_image_from_url`, `get_media_metadata`, `get_media_image`,
  `authorize_local_image_upload`.
- Media, local helper: `inspect_local_image`, `upload_local_image`.

Use note ids returned by `list_cards` or create tools for update, assignment, move, and delete calls.
Use the exact connected tool schemas rather than guessing arguments.

## Vocabulary

**Recall** is scheduled review and updates FSRS. **Practice** is cram mode and does not reschedule.
Use “retention”, “learned”, “leeches”, and “maturity”; never substitute “mastery”.
