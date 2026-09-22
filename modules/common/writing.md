# Writing

Applies to everything you write. Work in the spirit of "if I had more time, I
would have written a shorter letter".

## Plain language (ISO 24495-1)

- Lead with the conclusion.
- One fact per sentence. Active voice. Concrete nouns.
- Literal wording, so it reads clearly for non-native English speakers.
- Cut any sentence that does not change what the reader does.
- No em dashes, emojis, short dramatic sentences, or LLM-isms ("certainly!",
  "great question", "I'd be happy to", "let's dive in").

## Comments

Write as few as possible, and none for what the code already says.

- Do not explain what a line does.
- Do not refactor to avoid a comment. Deleting it is the fix.
- Keep only what the code cannot carry: a non-obvious external fact, a
  constraint, or why an obvious alternative was rejected.

## Commits, PRs, and issues

- Write PR descriptions by hand. Detail belongs in the linked issue.
- Commit subjects lowercase and imperative. The body says why, not what.
- Update docs in the same PR as the change.
