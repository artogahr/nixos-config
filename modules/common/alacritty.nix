# /nixos-config/modules/alacritty.nix
{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Cascadia Code";
        };
        size = 14.0;
      };
      window = {
        opacity = 0.90;
        blur = true;
        padding = {
          x = 10;
          y = 10;
        };
        dynamic_padding = true;
      };
      cursor = {
        style = "Beam";
      };
    };
  };
}

