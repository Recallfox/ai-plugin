---
name: recallfox
description: Capture what the user is learning into recallfox as spaced-repetition cards. Use when the user wants to remember something, says "add this to recallfox", "make cards", "recall this", or right after you have explained or taught something worth retaining. Creates decks and cards via the recallfox MCP connector.
---

# recallfox

recallfox is a spaced-repetition flashcard app (FSRS scheduler). This skill turns things
the user learns in a conversation into cards that the app will resurface over time, so the
knowledge actually sticks.

The recallfox MCP connector (server name `recallfox`) provides the tools. The user
authorizes it once via OAuth in their client; every tool call is scoped to their account.

## When to use

- The user explicitly asks: "add this to recallfox", "make cards for this", "recall this",
  "I want to remember this".
- Proactively, after you teach or explain something durable (a definition, an API, a
  command, a concept): offer to capture it. Do not create cards silently without a clear
  signal or an offer the user accepted.

## Vocabulary (use the app's terms, exactly)

- **Recall** is the scheduled review session; it feeds the FSRS scheduler and reschedules
  cards. **Practice** is cram mode; it does not reschedule. When you create cards you are
  adding to the user's recall queue.
- A **deck** groups cards by topic. A **card** (note) is one of two kinds:
  - **Basic** has a front (the prompt) and a back (the answer).
  - **Cloze** is a single sentence with the words to hide wrapped in square brackets, e.g.
    `The mitochondria is the [powerhouse] of the cell.` recallfox blanks out the bracketed
    parts and asks the user to fill them in.
- Standard spaced-repetition terms apply: a card matures as it is recalled correctly over
  longer intervals; a card the user keeps failing is a **leech**. Use "retention",
  "learned", "leeches", "maturity". Never invent terms like "mastery".

## Choosing what to capture (be selective, never force cards)

This is the most important rule: **do not turn everything into a card.** Most of what is said
in a conversation does not belong in long-term memory. Your job is to pick the few things
genuinely worth remembering, not to maximize card count.

- **Propose, do not impose.** Select only the facts that are durable, reusable, and worth the
  user's future review time. Skip the obvious, the trivia they will never need, and anything
  tied to this one conversation.
- **Always show the proposed cards and let the user choose.** Present the shortlist (the
  question/answer or the cloze sentence per card) and let them drop, edit, or add before
  anything is created. Never create cards silently, and never create a card the user did not
  agree to.
- If nothing is really worth keeping, say so and create nothing. Zero good cards beats ten
  filler cards.

## Choosing the card type

- Use **basic** when the knowledge is naturally a question and a distinct answer
  ("What does `git rebase` do?").
- Use **cloze** when the answer is a word or phrase living inside a sentence, or when the
  surrounding sentence is the context that makes it meaningful (definitions, key terms in a
  statement, fill-in-the-blank facts). Wrap each hidden span in `[brackets]`.

## Writing good cards (this matters more than volume)

- **Atomic:** one idea per card. Split compound facts into several cards.
- **Minimal:** the answer is the smallest thing that makes the card correct.
- **Context-free:** a card must make sense months later, with no memory of this chat. Do
  not write "the function we discussed"; name it.
- **Test recall, not recognition:** ask the user to produce the answer, not pick it.
- Prefer 5 sharp cards over 20 padded ones. Quality of recall beats coverage.

## How to create cards

1. Pick or create a deck. List existing decks first so you reuse one instead of making a
   near-duplicate. Create a new deck only when nothing fits.
2. Draft a short, selective shortlist of candidate cards (basic and/or cloze).
3. Show them to the user with the target deck and let them choose what to keep.
4. Create only the cards they kept.

## Tools

The `recallfox` MCP server exposes deck and card operations: list decks, create a deck,
create a **basic** front/back card, and create a **cloze** `[bracketed]` card. Discover the
exact tool names and arguments from the connected server rather than assuming them, and
prefer reusing an existing deck over creating one.
