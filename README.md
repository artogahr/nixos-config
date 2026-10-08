# fukurowl system configs

My system and user configuration, managed with Nix flakes. NixOS configures the
Linux machines, nix-darwin configures macOS, and Home Manager manages user packages
and dotfiles on both. `flake.lock` pins the dependencies used to build each host.

New to Nix? Start with [nix.dev](https://nix.dev/), the official documentation and tutorials.

## Hosts

| Host | System | Role |
| --- | --- | --- |
| `fukurowl-pc` | NixOS | Desktop |
| `fukurowl-thinkpad` | NixOS | Laptop |
| `fukurowl-devbox` | NixOS | Headless VM |
| `fukurowl-macbook` | nix-darwin | MacBook |

## Structure

```text
flake.nix                 Flake inputs, host definitions, and module imports
flake.lock                Pinned dependency versions
hosts/                    Per-host settings, hardware, and disk layouts
home-linux.nix            Linux Home Manager entry point
home-darwin.nix           macOS Home Manager entry point
modules/
  common/                 Shared user configuration
  common-system/          Shared system configuration
  linux/
    nixos/                NixOS system configuration
    home/                 Linux user configuration
  darwin/
    nix-darwin/           macOS system configuration
    home/                 macOS user configuration
scripts/                  Rebuild helpers
presets/                  Application presets
wallpapers/               Shared wallpapers
```

The module directories import their immediate `.nix` files automatically.
`desktop/` subdirectories under `common-system/`, `linux/nixos/`, and `linux/home/`
are imported separately for graphical hosts. The headless VM skips them.

## Working with the config

Put changes in the directory matching their scope: shared or platform-specific,
system or user. Keep host-specific settings in `hosts/<hostname>/`. New module
files in the existing imported directories need no changes to `flake.nix`.
Stage new files with `git add` so the Git-backed flake includes them.

On an existing configured host, apply changes from the repository root:

```sh
bash scripts/switch
```

The script fetches the flake inputs as your user, then runs the platform's rebuild
command with elevated privileges to activate the configuration. It requires
access to the private secrets repository and a local age key (see below).
The `nrs` shell alias runs the same script from `~/workplace/nixos-config`.

To update all pinned dependencies, or just one input:

```sh
nix flake update
# Or update one input:
nix flake update nixpkgs
```

Rebuild after updating and commit `flake.lock` with the change.

To add a host, create its configuration under `hosts/` and register it in
`flake.nix`, using an existing host with the same platform as a starting point.

## Secrets

Encrypted secrets live in the private [nix-secrets](https://github.com/artogahr/nix-secrets)
repository, included as a flake input. sops-nix decrypts them using each host's age
key at `~/.config/sops/age/keys.txt`.

A new host needs read access to that repository and its own age key. Add the
public key to `.sops.yaml` in `nix-secrets`, run `sops updatekeys secrets.yaml`,
and push the change. Keep the private key outside Git with file permissions `600`.

After changing the secrets repository, run `nix flake update nix-secrets` here,
rebuild, and commit the updated lock file.
