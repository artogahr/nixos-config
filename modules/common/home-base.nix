# Cross-platform home-manager baseline.
# Shared by every host (NixOS and nix-darwin).
{ pkgs, ... }:
let
  aiGuidelines = ./ai-guidelines.md;
in
{
  home.stateVersion = "25.05";

  manual.manpages.enable = false;

  programs.home-manager.enable = true;
  programs.uv.enable = true;

  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  catppuccin.flavor = "frappe";
  catppuccin.fish.enable = false;
  catppuccin.nvim.enable = false;

  home.packages = with pkgs; [
    bat
    btop
    claude-code
    direnv
    zellij
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".claude/ai-guidelines.md" = {
    source = aiGuidelines;
    force = true;
  };
  home.file.".claude/CLAUDE.md" = {
    text = "@ai-guidelines.md\n";
    force = true;
  };
}
