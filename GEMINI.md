# recallfox

You can push what the user learns into recallfox, their spaced-repetition retention layer,
using the recallfox MCP tools. recallfox stores knowledge as decks of cards and resurfaces
them over time with spaced repetition so the knowledge sticks.

## Available tools

- **list_decks** — list the user's decks and their card counts.
- **create_deck** — create a new deck.
- **create_basic_card** — create a front/back card.
- **create_cloze_card** — create a cloze-deletion card.

## How to capture well

- **Only with consent.** Propose the cards first (each front/back or cloze sentence plus the
  target deck), let the user drop, edit, or add, and create only what they accepted. Never
  create cards silently or as a side effect. Zero cards is a fine outcome.
- **Reuse a deck** when one fits; list decks before creating a new one.
- **One idea per card.** Keep cards atomic and context-free so they make sense on their own.
- **Cloze syntax** uses square brackets: wrap the answer to hide in `[brackets]`.
- **Vocabulary:** recallfox separates Recall (scheduled review that drives the scheduler)
  from Practice (cram that does not reschedule). Use the app's own terms.
