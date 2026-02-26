# NixOS configuration for fukurowl

This repo contains the flake‑based NixOS configuration for my desktop and ThinkPad, plus a shared home‑manager setup 

The goal of this README is just to say **where things live** and **how to use them**, not to document every option.

---

## Layout

- **`flake.nix`**
  - Main entry point; defines inputs and `nixosConfigurations` for:
    - `fukurowl-pc` (desktop)
    - `fukurowl-thinkpad` (laptop)
  - Both hosts import:
    - `configuration.nix` – shared NixOS config
    - `home.nix` – shared home‑manager config for `arto`
    - Per‑host `hardware-configuration.nix` and `disko-config.nix` under `hosts/<name>/`.

- **`hosts/<name>/`**
  - `default.nix` – host‑specific options (kernel, hardware, services, power tuning, etc.).
  - `hardware-configuration.nix` – auto‑generated; don’t edit by hand.
  - `disko-config.nix` – disk layout for that machine.

- **`home.nix`**
  - Home‑manager entry for `arto`.
  - Imports:
    - `modules/common/*.nix` – editor/shell/CLI app configs shared across hosts.
    - `modules/linux/*.nix` – desktop‑oriented home‑manager modules (niri, EasyEffects, Plasma tweaks, etc.).

- **`configuration.nix`**
  - Shared NixOS config: Nix settings, bootloader, networking, services, user `arto`, PipeWire, virtualization, theming, etc.
  - Imports:
    - `applications.nix` – global `environment.systemPackages`.
    - `desktop-shell.nix` – selects between DMS and Plasma and wires display/desktop managers.
    - `mime-associations.nix` – default apps for common MIME types.

- **Other notable pieces**
  - `desktop-shell.nix` – `desktop.shell = "dms" | "plasma"`; drives greeter, compositor, and shell‑specific bits.
  - `presets/easyeffects/` – EasyEffects audio presets used by the modules.
