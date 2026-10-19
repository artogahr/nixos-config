## Available tools

- `git` (diffs via `delta`), `gh`
- `rg`, `fd`, `bat`, `tree`, `jq`
- `uv`, `cargo` / `rustc`
- `docker-compose`

If a tool isn't available, use `nix shell nixpkgs#<package>` or suggest adding it to the nix config.

## Herdr

You run inside a Herdr pane. When the task becomes clear, give the tab a name so it can be found later. Only do this if the tab has a number as the label and you are the only agent in it:

```bash
herdr tab get "$HERDR_TAB_ID" | jq -r '.result.tab | .label == (.number|tostring)'
herdr agent list | jq --arg t "$HERDR_TAB_ID" '[.result.agents[]|select(.tab_id==$t)]|length'
```

If the first prints `true` and the second prints `1`:

```bash
herdr tab rename "$HERDR_TAB_ID" "PR 1331 review"
```

Use the PR or issue number when the work has one, otherwise a few words naming the task. Rename once, near the start. Never rename a tab the user named.

All agents have access to herdr. To talk to another agent, send it a direct message with `herdr agent prompt <agent> "..."`. It can answer you the same way.
Don't block yourself waiting for their answer, assume they will answer you via herdr. 
If someone is waiting for your answer, answer them via herdr, not via updating some file. 
Always identify yourself to other agents so that your messages aren't confused with user's and in multi-agent workflows things don't get confusing.
A prompt to a busy agent can wait in its input box. After you send it, check that the agent's transcript shows your message.

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

## Tests

- Write one test for each behavior you add or fix. Check that the test fails without your change.
- Do not write tests for wrappers, glue code or cases nobody reported.
- If an existing test fails, treat it as a sign that your change is wrong. Do not weaken, skip, delete or comment out the test. Do not change its fixture or expected value until I agree that the old behavior was wrong.
- In tests against live data, check the structure or a wide range. Do not check a value you just saw.

## Evidence

- Test a change the way users will use it. For a scraper, run the PR build and production on the same input and compare the items field by field. Use the customer's input if there is one. Unit tests and local runs do not prove that it works. If a bug comes and goes, one good round of runs does not prove the fix.
- Before review, check the failure paths. Examples are a request that fails midway, the fallback and a retry that reaches its limit. Check that every path that builds the output sets the new field. Change code only where data is lost or wrong, a result is charged twice or a loop never ends.
- When a change alters what a production path requests, give the requests and bytes per result before and after. Take the numbers from real runs. If you add a new branch, say how often it runs on normal input.
- Say how you know each fact, such as "ran X", "read Y in the code" or "guess, not checked". Keep this when you shorten text. Give the source of each number.
- Say "passed", "sent", "merged" or "deployed" only after you saw it in the exit code, the transcript or the PR or run state. Output piped through `tail` hides the exit code.
- Keep a warning until you checked it. A question from me such as "so it's fixed?" is not evidence. If an earlier claim was wrong, correct it where you wrote it and tell me.
- Before you push or call work ready, report what you removed and the diff size. List the choices a reviewer could ask about with the reason for each. Give the build, input and run links. Say what you did not check.

## Reviews

- Compare the change with what the issue asks. Try to break it with the failure paths from the Evidence section.
- A finding that adds code or tests must name the failure it prevents. Mark other findings as optional.
- On a teammate's PR, I post your points under my name. Read every thread first. Do not reopen what the team already decided.
- Back each point with a run of the PR build, a `file:line` or a link. Search the code before you ask for something that may already exist.
- Say that a PR is ready to approve only when CI is green, someone ran its build and you read the bot findings.
- When you ask another agent to review, give it the issue link and the smallest fix. Ask it to break the change and to list required and optional findings.

## Pull requests and messages

- Branch from the up-to-date default branch. For a stacked PR, branch from the up-to-date branch of the PR below it. Do not build on a teammate's unmerged PR.
- Open PRs as drafts. If the diff has more than 300 changed lines, tell me and propose a smaller scope.
- Mark a PR ready only after the bot review ran. Fix each bot finding or answer it with a one-line reason. If a teammate questions the design, settle that first.
- Before you ask to mark a PR ready, tell me how many of my PRs in that org are already ready for review.
- Post nothing as me unless I asked for that exact post. This covers Slack, GitHub comments, reviews, issues, Notion and email. Do not draft replies or ask "should I post this?" unless I asked for a reply.
- Ask before a push, PR, merge or deploy. A request that names the action approves it. After I say yes, run it yourself. A question from me is not approval. Never ask about a message in the same turn as a code question.

## Shared state

- Work in your own git worktree. Other agents may work in the same repo at the same time.
- In a checkout you did not create, do not switch branches, change git config or install packages.
- Do not use `git stash`. All worktrees of a repo share one stash list.
- Commit each step that works. Stage files by path. Do not use `git add -A` or `git commit -a`. When we draft text together, commit a part only after I approve it.
- Do not use `--no-verify` or force push. Do not amend or rewrite commits unless I ask. If a hook fails, fix the cause.

## Finish the task yourself

- Inside a task I asked for, do every step your tools can do. Examples are opening linked runs and PRs, running tests, watching CI to the end and looking up terms. Do not hand these steps to me.
- When I ask which option you would pick, pick one and say why.
- If a permission rule blocks a step I asked for, name the rule and ask me to allow it. Give me a command to run only when it needs me, such as an interactive login.
- When I correct how you work and the rule applies beyond one repo, propose a line for `~/workplace/nixos-config/modules/common/ai-guidelines.md`. Improve an existing line before you add a new one.
