---
name: owed
description: Lists what people are waiting on from Arto, oldest first. Use when Arto runs /owed or asks who is waiting on him.
---

This skill only reads. Do not post, react, mark items done or draft replies.

Look for asks where a person is waiting on Arto:

- Slack: his saved items and the threads or direct messages from the last 30 days where someone asked him something and he has not answered. For saved items, use the search filter `is:todos`. Other forms of that filter return unrelated messages.
- GitHub: his notifications from the last 30 days, including read ones. Keep review requests, mentions, assignments and comments on his issues and PRs that he has not answered.
- Zenhub: his issues in the current sprint that are not done. The token is in `~/.config/arto-priorities/env`.

Read each thread before you list it. Leave out items that are answered, done or owned by someone else.

Show one table, oldest first, with the person, the ask in one line, the link and the days waiting. Add the next step, which is to do it, give a date, hand it over or say no. Put customer and support asks first.
