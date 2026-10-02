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

## OpenRouter relay in OpenCode and Pi

Both agents use the [OpenRouter relay Actor](https://apify.com/artogahr/openrouter-relay) with your Apify API token. The token is encrypted in `secrets/apify-token.enc` with sops-nix. The repo also contains a password-encrypted copy of the age key at `secrets/apify-age-key.age`.

On each new host, pull this config and run the switch as your normal user:

```sh
bash scripts/switch
```

If the age key is missing, the switch asks for the bootstrap passphrase before rebuilding. It installs the key at `~/.config/sops/age/keys.txt` with mode `600`. Later switches decrypt the token automatically without a password prompt. Keep the bootstrap passphrase in your password manager. Anyone with the public repo can try to guess it offline, so use a long random passphrase when rotating it.

Rebuild the host, then select any available `openrouter` model in OpenCode's `/models` picker or Pi's `/model` picker. On NixOS, OpenCode starts with `openrouter/openrouter/auto`; on macOS, it keeps the local omlx default. Pi keeps its built-in OpenRouter model catalog. If Pi has an OpenRouter key saved through `/login`, run `/logout` for OpenRouter so its stored key does not override the relay token.

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
