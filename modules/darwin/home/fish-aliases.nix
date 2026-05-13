# macOS-only fish aliases (nix-darwin rebuild shortcuts).
{ ... }:
{
  programs.fish.shellAliases = {
    nrs = "sudo darwin-rebuild switch --flake $HOME/workplace/nixos-config";
    nos = "nh darwin switch $HOME/workplace/nixos-config";
  };
}
