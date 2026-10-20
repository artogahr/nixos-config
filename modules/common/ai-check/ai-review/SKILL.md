---
name: ai-review
description: Review a change against Arto's rules for code and writing. Use when Arto asks for a review before he pushes or opens a PR.
---

Review the change Arto names. If he names none, review the uncommitted changes and the commits that are not pushed yet. Read the code around the diff too. Treat commit messages as claims to check.

Report only these problems:

1. A new test that a developer on this team would not have written. For each new test, read the code it tests, that code's callers, the other tests in the same file and the issue if one is linked. Then decide if what it checks can fail and if the situation can happen in production. Report it if it repeats another test, only checks a log line or a message, checks code this change did not touch, sets up a situation that cannot happen or checks something that cannot fail.
2. A comment that says what the code does or that records history, such as PR or issue numbers, dates or "previously".
3. Code the change does not need. Examples are options no caller passes, checks for states that cannot happen, helpers with one caller and fallbacks for errors nobody reported. Search for callers before you report one.
4. A new or longer `memory/` entry that repeats what the code, a commit message or the issue already says.
5. Text in comments, docs, commit messages or PR text that breaks writing.md.

Do not report a comment that states an external fact, a constraint or the reason an obvious alternative was rejected.

Write each problem on one line as "path:line", the problem and what to change. Put the most important first. If you find nothing, say so in one line. Do not edit files.
