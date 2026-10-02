# Linux-only fish aliases (NixOS rebuild shortcuts).
{ ... }:
{
  programs.fish.shellAliases = {
    nrs = "bash $HOME/workplace/nixos-config/scripts/switch";
    nos = "bash $HOME/workplace/nixos-config/scripts/switch nh";
  };
}
