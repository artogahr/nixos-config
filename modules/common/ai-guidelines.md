## Available tools

- `git` (diffs via `delta`), `gh`
- `rg`, `fd`, `bat`, `tree`, `jq`
- `uv`, `cargo` / `rustc`
- `docker-compose`

If a tool isn't available, use `nix shell nixpkgs#<package>` or suggest adding it to the nix config.

## Herdr

You run inside a Herdr pane. When the task becomes clear, give the tab a name so
it can be found later. Only do this if the tab has a number as the label and you are the only agent in it:

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

If you need to talk to other agents, you can assume they have herdr skill too and can talk back.
Don't block yourself waiting for their answer, assume they will answer you via herdr. 
If someone is waiting for your answer, answer them via herdr, not via updating some file. 
Always identify yourself to other agents so that your messages aren't confused with user's and in multi-agent workflows things don't get confusing.
