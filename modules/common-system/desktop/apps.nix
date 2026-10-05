# GUI apps for every graphical host (desktop NixOS + nix-darwin).
{ pkgs, ... }:
{
  # GUI/system apps go here, not in home.packages, so darwin indexes them in Spotlight.
  environment.systemPackages = with pkgs; [
    signal-desktop
    spotify
  ];
}
