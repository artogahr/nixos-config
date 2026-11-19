{ config, lib, ... }:
let
  home = config.home.homeDirectory;
in
{
  services.syncthing = {
    enable = true;
    settings = lib.recursiveUpdate (import ../../../syncthing.nix home) {
      folders.videos.path = "${home}/Movies";
    };
  };
}
