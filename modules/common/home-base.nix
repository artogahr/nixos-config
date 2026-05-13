# Cross-platform home-manager baseline.
# Shared by every host (NixOS and nix-darwin).
{ pkgs, ... }:
{
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    tree
    gh
    htop
    ripgrep
    fd
    delta
  ];

  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
}
