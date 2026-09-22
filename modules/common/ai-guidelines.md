Avoid em dashes, emojis, short dramatic sentences, and LLM-isms ("certainly!", "great question", "I'd be happy to", "absolutely", "of course", "let's dive in", "fascinating"). Write simply and directly. No filler, no theatre.

## Available tools

- `git` (diffs via `delta`), `gh`
- `rg`, `fd`, `bat`, `tree`, `jq`
- `uv`, `cargo` / `rustc`
- `docker-compose`

If a tool isn't available, use `nix shell nixpkgs#<package>` or suggest adding it to the nix config.

## Herdr

You run inside a Herdr pane. When the task becomes clear, give the tab a name so
it can be found later. Only do this if the tab still has its auto-generated
label and you are the only agent in it:

```bash
herdr tab get "$HERDR_TAB_ID" | jq -r '.result.tab | .label == (.number|tostring)'
herdr agent list | jq --arg t "$HERDR_TAB_ID" '[.result.agents[]|select(.tab_id==$t)]|length'
```

If the first prints `true` and the second prints `1`:

```bash
herdr tab rename "$HERDR_TAB_ID" "PR 1331 review"
```

Use the PR or issue number when the work has one, otherwise a few words naming
the task. Rename once, near the start. Never rename a tab the user named.
