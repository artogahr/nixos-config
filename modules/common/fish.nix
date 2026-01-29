{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      ll = "ls -alh";
      nrs = "sudo nixos-rebuild switch --flake $HOME/workplace/nixos-config";
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
