# herdr on nix-darwin + home-manager: research notes

Researched 2026-08-18 against primary sources only (herdr.dev docs, herdrdev/herdr source,
nix-community/home-manager master, NixOS/nixpkgs master).

## Recommendation

Use **nixpkgs `herdr` + home-manager's `programs.herdr` module**. This repo already tracks
`nixpkgs/nixos-unstable` and home-manager **master** (`flake.nix` lines 6 and 13), which is
exactly what's required — the module is master-only, and nixpkgs unstable carries the latest
stable herdr (0.8.0) with Hydra-built binaries for aarch64-darwin.

```nix
programs.herdr = {
  enable = true; # package defaults to pkgs.herdr
  settings = {
    onboarding = false; # important: see "config writes" below
    # ... see https://herdr.dev/docs/configuration/
  };
};
```

The module writes `~/.config/herdr/config.toml` via `pkgs.formats.toml` and runs
`herdr server reload-config || true` on change, so a running server picks up edits after
`darwin-rebuild switch`. Do **not** use the upstream flake as the package source: it builds
from source (full Rust + Zig toolchain) with no binary cache, per the herdr org's own
[herdr-nix README](https://github.com/herdrdev/herdr-nix).

Leave the Claude/Kimi agent integrations (`herdr integration install claude|kimi`) imperative —
herdr owns those files and bumps an embedded version marker on updates (details below).

## Findings

### 1. home-manager module: `programs.herdr` exists on master

- Module request [nix-community/home-manager#9566](https://github.com/nix-community/home-manager/issues/9566)
  closed 2026-06-30 by merged PR [#9567 "herdr: init module"](https://github.com/nix-community/home-manager/pull/9567).
- Source: `modules/programs/herdr.nix` on master
  (<https://github.com/nix-community/home-manager/blob/master/modules/programs/herdr.nix>),
  maintainer `amadejkastelic`. Tests under `tests/modules/programs/herdr/`.
- Options: `enable`, `package` (`mkPackageOption pkgs "herdr" { nullable = true; }`), and
  free-form `settings` rendered with `pkgs.formats.toml` to
  `xdg.configFile."herdr/config.toml"`. `onChange` runs `<herdr> server reload-config || true`
  (added in [#9662](https://github.com/nix-community/home-manager/pull/9662), fixed for
  `package = null` in [#9681](https://github.com/nix-community/home-manager/pull/9681)).
- Open PR [#9815](https://github.com/nix-community/home-manager/pull/9815) adds a `plugins`
  option with idempotent registration — not merged yet.
- **Not in any release branch**: `modules/programs/herdr.nix` is absent from `release-26.05`
  and `release-25.11` (404 via GitHub contents API; merge date 2026-06-30 postdates the 26.05
  branch-off). Master-only until 26.11. This repo tracks master, so no action needed.

### 2. Upstream flake: package/devShell/overlay only, no modules

`github.com/herdrdev/herdr/flake.nix` (master) exports, for
x86_64/aarch64 linux+darwin:

- `packages.<system>.{herdr,default}` — built from source via `nix/package.nix` with a
  rust-overlay toolchain pinned by `rust-toolchain.toml`
- `apps.default`, `checks`, `devShells.default` (cargo-nextest, cmake, just, ninja, zig 0.15…),
  `formatter`
- `overlays.default` — composes rust-overlay and adds `herdr = callPackage ./nix/package.nix`

**No** `homeManagerModules`, `darwinModules`, or `nixosModules`.
Source: <https://github.com/herdrdev/herdr/blob/master/flake.nix>.

### 3. Community flakes

- [herdrdev/herdr-nix](https://github.com/herdrdev/herdr-nix) — **official org repo**. Wraps
  herdr's prebuilt per-platform release binaries (incl. `herdr-macos-aarch64`) in a derivation;
  pushes protected-main builds to the public Cachix cache `herdr`. Active (pushed 2026-08-05).
  Useful where nixpkgs lags or for devenv; not needed here since nixpkgs is current.
- [AodhanHayter/herdr-nix](https://github.com/AodhanHayter/herdr-nix) and
  [kevinpita/herdr-nix](https://github.com/kevinpita/herdr-nix) — third-party hourly-updated
  packaging flakes, 1 star each (kevinpita is also a nixpkgs herdr maintainer).
- [yigitkonur/awesome-herdr](https://github.com/yigitkonur/awesome-herdr) has **no** Nix/
  home-manager section — only incidental mentions inside listed dotfiles repos.
- No community home-manager module exists; none is needed given the upstream HM module.

### 4. Config management

- Confirmed at <https://herdr.dev/docs/configuration/>: TOML at `~/.config/herdr/config.toml`
  (Linux/macOS); `herdr --help` prints the resolved path. Reload:
  `herdr server reload-config` ("applies most UI settings without restarting panes;
  startup-only settings still need a restart").
- **herdr writes to its own config in two cases** (same page): completing first-run onboarding
  writes `onboarding = false`, and manually picking a theme in Settings disables
  `theme.auto_switch`. With home-manager managing the file it becomes a read-only store
  symlink, so: set `onboarding = false` in `settings` and change themes declaratively rather
  than via the in-app Settings UI.
- Session/mutable state lives outside the managed file — worktrees at `~/.herdr/worktrees`,
  logs at `~/.config/herdr/herdr.log` (same docs page) — so declaring only `config.toml`
  leaves state mutable, which is what the HM module does.
- The `xdg.configFile."herdr/config.toml".source = (pkgs.formats.toml {}).generate ...`
  pattern is moot here: the upstream module *is* that pattern (see module source above), so
  use the module instead of hand-rolling it.

### 5. Package status

- Latest upstream stable: **v0.8.0** (2026-08-03); newer tags are only rolling `preview-*`
  builds (latest `preview-2026-08-17-…`).
  Source: <https://github.com/herdrdev/herdr/releases>.
- nixpkgs master: `pkgs/by-name/he/herdr/package.nix`, `version = "0.8.0"`, maintainers
  `kevinpita`, `faukah`, `platforms = lib.platforms.unix` (aarch64-darwin included, Hydra-cached).
- Actively maintained: 0.7.3→0.7.4 merged 2026-07-17, →0.7.5 merged 2026-07-23 (2 days after
  release), →0.8.0 merged 2026-08-07 (4 days after release), plus follow-ups
  ([#546881](https://github.com/NixOS/nixpkgs/pull/546881) SKILL.md distribution). No
  significant lag; nixpkgs is the right source. If a future release lags, prefer
  `herdrdev/herdr-nix` (cached binaries) over the source-building upstream flake.

### 6. herdr-specific notes

- Nix is **officially documented**: <https://herdr.dev/docs/install/#install-with-nix> gives
  `nix run|build|profile install github:herdrdev/herdr/v0.x.y` and
  `nix develop github:herdrdev/herdr`. It does not mention nixpkgs or home-manager.
- Agent integrations (docs: <https://herdr.dev/docs/integrations/>; code:
  `src/integration/targets.rs`, `src/integration/claude_settings.rs` in herdrdev/herdr):
  - `herdr integration install claude` writes `~/.claude/hooks/herdr-agent-state.sh` (a static
    bundled asset, `src/integration/assets/claude/herdr-agent-state.sh`) **and edits
    `~/.claude/settings.json`** to add hook entries. Respects `CLAUDE_CONFIG_DIR`.
  - `herdr integration install kimi` writes `~/.kimi-code/hooks/herdr-agent-state.sh` and
    appends a herdr-managed `[[hooks]]` block to `~/.kimi-code/config.toml`. Respects
    `KIMI_CODE_HOME`.
  - **Deviation applied in this repo (2026-08-18)**: `~/.claude/settings.json` is itself a
    read-only store symlink here (`programs.claude-code.settings` in
    `modules/common/home-base.nix`), so `herdr integration install claude` fails with EACCES on
    the settings merge. Resolution: the hook *script* stays herdr-managed (the install command
    wrote it to `~/.claude/hooks/` before failing), and the single `hooks.SessionStart` entry it
    needs is declared in `programs.claude-code.settings` instead. Kimi's config is not
    nix-managed, so `herdr integration install kimi` worked as-is.
  - **Skill**: the nixpkgs package ships the agent skill at
    `$out/share/herdr/skills/herdr/SKILL.md` (added in nixpkgs PR #546881), so no
    `npx skills add` is needed — `modules/common/herdr.nix` symlinks it into
    `~/.claude/skills/herdr` (Claude Code + opencode) and `~/.kimi-code/skills/herdr` (Kimi
    auto-discovers `.kimi-code/skills` and `.agents/skills`).
  - The hook scripts are plain files and *could* be declared via `home.file`, but each embeds
    `# HERDR_INTEGRATION_VERSION=N` (Claude currently v8) which herdr bumps across releases —
    `herdr integration status` and native session restore check that version, and the script
    header says "managed by herdr; reinstalling or updating the integration overwrites this
    file". A pinned declarative copy would silently go stale, and the `settings.json` /
    `config.toml` edits are merges into files herdr doesn't own. **Keep integrations
    imperative**: rerun `herdr integration install claude` after herdr upgrades. Integration
    state lives entirely in those agent config dirs; herdr's own config/state is untouched.
