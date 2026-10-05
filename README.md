# fukurowl system configs

Flake-based system configuration for my hosts. NixOS for Linux machines, nix-darwin for the
MacBook. Home-manager handles everything user-level on both.

## Hosts

| Host                | Platform   | Builder               |
| ------------------- | ---------- | --------------------- |
| `fukurowl-pc`       | NixOS      | `bash scripts/switch` |
| `fukurowl-thinkpad` | NixOS      | `bash scripts/switch` |
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
modules/
  common/              # cross-platform home-manager (fish, git, neovim, atuin, …)
  linux/
    nixos/             # NixOS system-level (auto-imported)
    home/              # Linux-only home-manager (ghostty, plasma, gtk, mime, …)
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
directory and rebuild — no flake edits required.

## Secrets

Secrets live sops-encrypted in the private [`artogahr/nix-secrets`](https://github.com/artogahr/nix-secrets) repo, pulled in as the `nix-secrets` flake input. Nothing secret is in this public repo. `modules/common/secrets.nix` decrypts them with sops-nix and exports the MCP credentials (`REDASH_API_KEY`, `HOMEASSISTANT_TOKEN`, `MEZMO_API_KEY`, `LANGFUSE_AUTH`) to interactive fish shells.

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

## Adding a new module

1. Decide the scope:
   - Works on Linux **and** macOS, user-level → `modules/common/`
   - Linux user-level only → `modules/linux/home/`
   - NixOS system option → `modules/linux/nixos/`
   - macOS user-level only → `modules/darwin/home/`
   - nix-darwin system option → `modules/darwin/nix-darwin/`
2. Write a `{ ... }: { … }` module file.
3. Rebuild.
