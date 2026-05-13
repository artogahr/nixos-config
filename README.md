# fukurowl system configs

Flake-based system configuration for my hosts. NixOS for Linux machines, nix-darwin for the
MacBook. Home-manager handles everything user-level on both.

## Hosts

| Host                | Platform   | Builder                       |
| ------------------- | ---------- | ----------------------------- |
| `fukurowl-pc`       | NixOS      | `sudo nixos-rebuild switch`   |
| `fukurowl-thinkpad` | NixOS      | `sudo nixos-rebuild switch`   |
| `fukurowl-macbook`  | nix-darwin | `darwin-rebuild switch`       |

Switch with the flake target, e.g.

```sh
sudo nixos-rebuild switch --flake .#fukurowl-pc
darwin-rebuild switch --flake .#fukurowl-macbook
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

## Adding a new module

1. Decide the scope:
   - Works on Linux **and** macOS, user-level → `modules/common/`
   - Linux user-level only → `modules/linux/home/`
   - NixOS system option → `modules/linux/nixos/`
   - macOS user-level only → `modules/darwin/home/`
   - nix-darwin system option → `modules/darwin/nix-darwin/`
2. Write a `{ ... }: { … }` module file.
3. Rebuild.
