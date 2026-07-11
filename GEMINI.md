# recallfox

Use the recallfox MCP connector to turn durable knowledge into spaced-repetition cards and place it
coherently in the user's decks and topics.

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

## Learning Path rules

- Topic order gates only new-card introduction; started/due cards keep their FSRS schedules.
- Tell the user when new cards are being placed in a locked topic. Never silently study ahead.
- Ask before creating/renaming/deleting/reordering topics, moving existing cards, configuring the
  Learning Path, or studying ahead.
- Reassignment and cross-deck moves preserve schedules, progress, and review history.
- Retention is context, not “mastery” and not a reason by itself to restructure a deck.

## Card quality

- Basic cards use a distinct prompt and answer. Cloze cards hide answers in `[square brackets]`.
- One durable idea per card; minimal answer; context-free months later; test recall, not recognition.
- Prefer a few strong cards to broad filler. Zero cards is a valid outcome.

## Tools

- Inspect: `list_decks`, `list_topics`, `list_cards`.
- Create: `create_deck`, `create_topic`, `create_basic_card`, `create_cloze_card`.
- Organize: `update_topic`, `delete_topic`, `reorder_topics`, `configure_learning_path`,
  `study_ahead`, `assign_cards_to_topic`, `move_cards_to_deck`.
- Maintain: `update_basic_card`, `update_cloze_card`, `delete_card`.

Use returned note ids for update, assignment, move, and delete operations. Recall is scheduled review
that updates FSRS; Practice is cram mode and does not reschedule.
