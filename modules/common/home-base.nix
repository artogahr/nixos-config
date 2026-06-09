# Cross-platform home-manager baseline.
# Shared by every host (NixOS and nix-darwin).
{ pkgs, ... }:
{
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  programs.uv.enable = true;

  home.packages = with pkgs; [
    tree
    gh
    htop
    ripgrep
    fd
    delta
  ];

  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  catppuccin.flavor = "frappe";
  catppuccin.fish.enable = false;
  catppuccin.nvim.enable = false;
}
