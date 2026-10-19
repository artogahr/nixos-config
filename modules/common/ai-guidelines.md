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

## Scope

- The linked issue sets the scope of a PR. Without an issue, my request sets the scope. Do everything in the scope even if the PR grows. Do nothing outside it.
- Before you write code, write the smallest fix in one or two lines. Add more than that only to prevent a failure you saw or tested. This includes a new module, option, retry, test, comment or memory entry. Name the failure.
- Fix the problem where it starts. Use the framework's own tools for it, such as routes, retries or schema defaults. A local workaround has fewer lines but fixes the wrong place. If the right fix needs a refactor, tell me and ask.
- At the end, list other problems you found as possible new issues. When I ask for the "proper" or "general" fix and it does more than the issue asks, tell me first.
- Ask me before you change what users see, such as output fields, error rows or charging. Show me one example output item.

## Before you build

- In a shared repo, check for open PRs at the start and again before you open a PR. Make sure the command printed a result, even if the result is an empty list.
- Read every comment on the issue. Open the threads, specs and PRs it links.
- Run `git log` on the files you will change. If an earlier attempt was reverted, read why.
- Read the repo's CONTRIBUTING, DEVELOPMENT and AGENTS docs before you open a PR.
- If someone already works on it, stop and tell me.
