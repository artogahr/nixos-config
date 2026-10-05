# fukurowl system configs

Flake-based system configuration for my hosts. NixOS for Linux machines, nix-darwin for the
MacBook. Home-manager handles everything user-level on both.

## Hosts

| Host                | Platform   | Builder               |
| ------------------- | ---------- | --------------------- |
| `fukurowl-pc`       | NixOS      | `bash scripts/switch` |
| `fukurowl-thinkpad` | NixOS      | `bash scripts/switch` |
| `fukurowl-devbox`   | NixOS (headless VM on proxmox2) | `bash scripts/switch` |
| `fukurowl-macbook`  | nix-darwin | `bash scripts/switch` |

Run the switch from this repository. The `nrs` alias uses the same script after the first switch.

```sh
bash scripts/switch
```

## Layout

```
flake.nix              # inputs + nixosConfigurations + darwinConfigurations
home-linux.nix         # home-manager entry: common + linux/home
home-darwin.nix        # home-manager entry: common + darwin/home
hosts/
  fukurowl-pc/         # NixOS host
  fukurowl-thinkpad/   # NixOS host
  fukurowl-macbook/    # nix-darwin host
  fukurowl-devbox/     # headless NixOS VM (dev agent box)
modules/
  common/              # cross-platform home-manager (fish, git, neovim, atuin, …)
  common-system/       # system modules for every host (auto-imported)
    desktop/           # GUI apps for graphical hosts (desktop NixOS + darwin)
  linux/
    nixos/             # NixOS system-level, desktop or headless (auto-imported)
      desktop/         # Plasma, audio, gaming, desktop apps (graphical hosts only)
    home/              # Linux-only home-manager (auto-imported)
      desktop/         # ghostty, plasma, gtk, mime, … (graphical hosts only)
  darwin/
    nix-darwin/        # macOS system-level (auto-imported)
    home/              # macOS-only home-manager
presets/easyeffects/   # EasyEffects audio presets (Linux)
wallpapers/            # Shared wallpapers
```

## How auto-import works

`flake.nix` walks `modules/<os>/{nixos,nix-darwin}/` and pulls every `.nix` file in as a
system module. The `home-linux.nix` / `home-darwin.nix` entry files do the same for
`modules/common/` plus the appropriate `modules/<os>/home/`. Drop a new module into the right
directory and rebuild — no flake edits required. `desktop/` subdirectories are not walked by the
common lists; `nixosDesktopModules` in `flake.nix` pulls them in for the graphical NixOS hosts,
and darwin imports `common-system/desktop` directly.

## Secrets

Secrets live sops-encrypted in the private [`artogahr/nix-secrets`](https://github.com/artogahr/nix-secrets) repo, pulled in as the `nix-secrets` flake input. Nothing secret is in this public repo. `modules/common/secrets.nix` decrypts them with sops-nix and exports the MCP credentials (`REDASH_API_KEY`, `HOMEASSISTANT_TOKEN`, `MEZMO_API_KEY`, `LANGFUSE_AUTH`) to every fish shell.

Each host has its own age key at `~/.config/sops/age/keys.txt`, kept in no repo. To add a host:

1. On the host: `nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt` (mode `600`).
2. In `nix-secrets`: add the printed public key to `.sops.yaml`, run `sops updatekeys secrets.yaml`, push.
3. Give the host read access to `nix-secrets` (a read-only deploy key on Linux hosts).
4. Here: `nix flake update nix-secrets`, commit the lock, pull on the host, `nrs`.

After editing a secret (`sops secrets.yaml` in `nix-secrets`, push), run `nix flake update nix-secrets` here and commit the lock. `scripts/switch` fetches the inputs as your user before the sudo rebuild, because root has no GitHub credentials.

## OpenRouter relay in OpenCode and Pi

Both agents use the [OpenRouter relay Actor](https://apify.com/artogahr/openrouter-relay) with your Apify API token (`apify-token` in `nix-secrets`).

Rebuild the host, then select any available `openrouter` model in OpenCode's `/models` picker or Pi's `/model` picker. OpenCode remembers the most recently selected model. In Pi, press `Ctrl+S` in the `/model` picker to save the selected model as the default for new sessions. Pi keeps its built-in OpenRouter model catalog. If Pi has an OpenRouter key saved through `/login`, run `/logout` for OpenRouter so its stored key does not override the relay token.

The relay currently inherits the upstream Actor's 2,048-token output limit for Chat and Responses requests. Long agent turns may stop at that limit.

## MCP servers in Pi

Pi gets the same MCP servers as the other agents, defined in `modules/common/pi.nix`: redash, notion, apify, home-assistant, and mezmo.

Notion and apify use OAuth. Run `pi mcp login notion` and `pi mcp login apify` once per host. redash, home-assistant, and mezmo read their credentials from the environment (`REDASH_API_KEY`, `HOMEASSISTANT_TOKEN`, `MEZMO_API_KEY` in fish's `conf.d/secrets.fish`), so no secret lives in this repo.

`mcp.json` is a read-only store symlink. View and sign in through `/mcp`, but change server definitions in `pi.nix` rather than in the TUI.

## Pi packages

Pi packages are installed with `pi install` and listed in the unmanaged `~/.pi/agent/settings.json`, so they are not declared in this repo. This host has:

```sh
pi install npm:pi-web-access
pi install npm:pi-agent-browser-native
pi install git:github.com/elpapi42/pi-fork
pi install npm:pi-codex-goal
pi install npm:pi-observational-memory
pi install npm:@hypabolic/pi-hypa
```

`pi-web-access` works with no keys. `pi-agent-browser-native` needs `agent-browser` on PATH (nixpkgs provides 0.38.1) and Pi 1.0.0 or newer. nixpkgs ships Pi 0.99.2, so browser automation does not work until Pi updates upstream.

## Adding a new module

1. Decide the scope:
   - Works on Linux **and** macOS, user-level → `modules/common/`
   - Linux user-level only → `modules/linux/home/` (GUI → `modules/linux/home/desktop/`)
   - NixOS system option → `modules/linux/nixos/` (GUI → `modules/linux/nixos/desktop/`)
   - macOS user-level only → `modules/darwin/home/`
   - nix-darwin system option → `modules/darwin/nix-darwin/`
2. Write a `{ ... }: { … }` module file.
3. Rebuild.
