---
name: owed
description: Lists what people are waiting on from Arto, oldest first. Use when Arto runs /owed or asks who is waiting on him.
---

This skill only reads. Do not post, react, mark items done or draft replies.

Look for asks where a person is waiting on Arto:

- On Slack, list his saved items and the threads or direct messages from the last 30 days where someone asked him something and he has not answered. For saved items, use the search filter `is:todos`. Other forms of that filter return unrelated messages. If you have no Slack tool, skip Slack and say so.
- On GitHub, list his notifications from the last 30 days, including read ones. Keep review requests, mentions, assignments and comments on his issues and PRs that he has not answered.
- In Zenhub, list his issues in the current sprint that are not done. Read `ZENHUB_TOKEN` from `~/.config/arto-priorities/env`. Never print it.

Read each thread before you list it. Leave out items that are answered, done or owned by someone else.

Show one table, oldest first, with the person, the ask in one line, the link and the days waiting. Add the next step. It is one of these: do it, give a date, hand it over or say no. Put customer and support asks first.
