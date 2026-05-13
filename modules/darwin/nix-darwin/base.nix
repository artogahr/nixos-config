# nix-darwin baseline shared by all macOS hosts.
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # We're using Determinate Nix, which manages its own daemon and config. Setting this
  # to false lets nix-darwin coexist with it. As a side effect, anything under `nix.*`
  # (settings, trusted-users, experimental-features, garbage collection, etc.) becomes
  # a no-op on this host — those are configured via Determinate's own mechanisms,
  # mostly /etc/nix/nix.custom.conf and `determinate-nixd` defaults. Flakes and
  # nix-command are already on by default in Determinate, so no extra config needed.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Prague";

  fonts.packages = with pkgs; [
    cascadia-code
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  programs.fish.enable = true;

  environment.etc.shells.text = ''
    /bin/bash
    /bin/csh
    /bin/dash
    /bin/ksh
    /bin/sh
    /bin/tcsh
    /bin/zsh
    /run/current-system/sw/bin/fish
  '';

  # nh doesn't have a nix-darwin module (NixOS and home-manager only), so we install
  # the binary directly. The `nos` fish alias passes the flake path explicitly, and
  # nh pulls in nix-output-monitor + nvd via its own runtime deps.
  environment.systemPackages = with pkgs; [
    nh
  ];

  users.users.artogahr = {
    home = "/Users/artogahr";
    shell = pkgs.fish;
  };

  # Enable Touch ID for sudo (writes /etc/pam.d/sudo_local).
  security.pam.services.sudo_local.touchIdAuth = true;

  # The user nix-darwin treats as the "primary" — required for some launchd / homebrew options.
  # macOS username (≠ the NixOS username on the other hosts, which is `arto`).
  system.primaryUser = "artogahr";

  # Pin nix-darwin's state version; bump this only when nix-darwin release notes tell you to.
  system.stateVersion = 6;
}
