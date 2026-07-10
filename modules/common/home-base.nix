# Cross-platform home-manager baseline.
# Shared by every host (NixOS and nix-darwin).
{ pkgs, ... }:
let
  aiGuidelines = ./ai-guidelines.md;
in
{
  home.stateVersion = "25.05";

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
    rtk
    zellij
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".claude/ai-guidelines.md".source = aiGuidelines;
  home.file.".claude/CLAUDE.md".text = "@RTK.md\n@ai-guidelines.md\n";
}
