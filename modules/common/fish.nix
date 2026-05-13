{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    # Cross-platform aliases only. OS-specific rebuild aliases (`nrs`, `nos`) live in
    # modules/linux/home/fish-aliases.nix and modules/darwin/home/fish-aliases.nix.
    shellAliases = {
      ".." = "cd ..";
      ll = "ls -alh";
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
