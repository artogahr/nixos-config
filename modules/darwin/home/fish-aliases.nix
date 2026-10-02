# macOS-only fish aliases (nix-darwin rebuild shortcuts).
{ ... }:
{
  programs.fish.shellAliases = {
    nrs = "bash $HOME/workplace/nixos-config/scripts/switch";
    nos = "bash $HOME/workplace/nixos-config/scripts/switch nh";
  };
}
