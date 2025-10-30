{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      ll = "ls -alh";
      nrs = "sudo nixos-rebuild switch --flake /nixos-config#fukurowl-pc && git -C /nixos-config commit -a";
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
