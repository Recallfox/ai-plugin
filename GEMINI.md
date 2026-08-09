# recallfox

Use the recallfox MCP connector to teach durable ideas through optional interactive Lessons, then
turn them into spaced-repetition cards and place them coherently in the user's decks and topics.

## Structure-aware capture

1. Inspect likely homes with `list_decks`, `list_topics`, and `list_cards`. Consider existing content,
   topic descriptions/order, progress, retention, and locked/unlocked state. Avoid duplicates.
2. Prefer an existing topic. Use General/default for a small capture. Propose a new topic only for a
   distinct concept with room to grow, and a new deck only when no cohesive deck fits.
3. Treat roughly 10–25 cards as a useful topic-size heuristic. Above about 25, propose a split only
   when a real conceptual seam exists; never create structure merely to satisfy a count.
4. Show proposed cards, placement, structural changes, and access consequences. Create or reorganize
   only after the user confirms. Never create silently.
5. After changes, call `list_topics` again and report the resulting order and access state.

recallfox currently exposes decks and exactly-one topic membership, not tags. Do not invent tag data.

## Interactive Lessons

When the user has just learned durable material and an example, flow, or manipulable model would add
real value, offer once to add a short interactive Lesson to the relevant topic so they can replay it
from the Learning Path. Wait for confirmation. Do not offer again after a decline, and never create
cards and a Lesson under one ambiguous consent.

Before authoring, inspect existing cards and Lessons with `list_cards`, `list_lessons`, and
`get_lesson`. Use the `author-lessons` skill. Lessons should teach one coherent objective through
examples and optional meaningful interaction. They are not quiz gauntlets: zero questions is valid,
and one or two checks are enough when they surface an important misconception.

Each step is body HTML with inline CSS/JavaScript and an explicit optional library list. Supported
ids are `alpine`, `motion`, `interact`, `katex`, `d3`, `cytoscape`, `p5`, and `mermaid`; pass `[]`
when native browser code is enough. Never add CDNs or network dependencies. Design for the 393 × 852
phone viewport, 320px minimum width, fluid height, touch and keyboard access, and no horizontal
scrolling. RecallFox owns Back, Continue, progress, and completion outside the frame.

Make every interaction discoverable without hover: prefer labelled buttons or tabs over a slider
for two to four discrete states, show a short visible action hint such as “Tap a stage,” and give
enabled controls hover, focus, active, and pointer-cursor cues. Keep essential instructions visible;
an info helper may contain optional detail only and must also open by tap and keyboard activation.

## Learning Path rules

- Topic order gates only new-card introduction; started/due cards keep their FSRS schedules.
- Tell the user when new cards are being placed in a locked topic. Never silently study ahead.
- Ask before creating/renaming/deleting/reordering topics, moving existing cards, configuring the
  Learning Path, or studying ahead.
- Ask before changing an existing deck's name, emoji, or description.
- Reassignment and cross-deck moves preserve schedules, progress, and review history.
- Retention is context, not “mastery” and not a reason by itself to restructure a deck.

## Images

Use images only when they materially teach the concept. For an online image, inspect the original
image and source page, confirm the source and reuse basis with the user, then call
`import_image_from_url`, then verify the stored result with `get_media_image`. For a local image, use local `inspect_local_image`, pass all returned file
facts to remote `authorize_local_image_upload`, and use its one-use token with local
`upload_local_image`. Never expose or reuse that token.

Bind the returned asset with a lowercase hyphenated alias. Cards reference it as
`![alt](rf-media-alias:alias)`. Lesson steps reference it as
`<img data-rf-media-alias="alias" alt="alt">`. Pass the matching `{alias, asset_id}` in the card or
step `media` list. Never put asset ids, S3 paths, or external URLs in authored content.

## Card quality

- Choose the retrieval behavior first and show the proposed type. Use Basic when the learner should
  produce an answer unaided; Cloze for an exact word or phrase in meaningful sentence context; and
  Options only when discriminating among plausible alternatives is itself the useful skill.
- Options are not easier Basic cards. Use three or four parallel choices when possible (two to four
  are supported), exactly one unambiguous answer, and only genuine distractors. Never invent facts
  just to fill choices; fall back to Basic when strong distractors do not exist. The back should
  explain the answer and, when useful, distinguish the closest distractor. Show all choices, the
  correct answer, and the explanation in the proposal.
- One durable idea per card; minimal answer; context-free months later. Prefer unaided recall; use
  recognition only when discrimination is the learning objective.
- Prefer a few strong cards to broad filler. Zero cards is a valid outcome.

## Tools

- Inspect: `list_decks`, `list_topics`, `list_cards`.
- Create: `create_deck`, `create_topic`, `create_basic_card`, `create_cloze_card`,
  `create_choice_card`.
- Organize: `update_deck`, `update_topic`, `delete_topic`, `reorder_topics`, `configure_learning_path`,
  `study_ahead`, `assign_cards_to_topic`, `move_cards_to_deck`.
- Maintain: `update_basic_card`, `update_cloze_card`, `delete_card`.
- Lessons: `list_lessons`, `get_lesson`, `create_lesson`, `update_lesson`, `add_lesson_step`,
  `update_lesson_step`, `reorder_lesson_steps`, `delete_lesson_step`, `reorder_lessons`,
  `delete_lesson`.
- Remote media: `import_image_from_url`, `get_media_metadata`, `get_media_image`,
  `authorize_local_image_upload`.
- Local media: `inspect_local_image`, `upload_local_image`.

Use returned note ids for update, assignment, move, and delete operations. Recall is scheduled review
that updates FSRS; Practice is cram mode and does not reschedule.
