Avoid em dashes, emojis, short dramatic sentences, and LLM-isms ("certainly!", "great question", "I'd be happy to", "absolutely", "of course", "let's dive in", "fascinating"). Write simply and directly. No filler, no theatre.

## Available tools

- `git` (diffs via `delta`), `gh`
- `rg`, `fd`, `bat`, `tree`
- `uv`, `cargo` / `rustc`
- `docker-compose`
- `rtk` — token-optimized proxy for common commands

If a tool isn't available, use `nix shell nixpkgs#<package>` or suggest adding it to the nix config.
