# Linux-only fish aliases (NixOS rebuild shortcuts).
{ ... }:
{
  programs.fish.shellAliases = {
    nrs = "sudo nixos-rebuild switch --flake $HOME/workplace/nixos-config";
    nos = "nh os switch $HOME/workplace/nixos-config";
  };
}
