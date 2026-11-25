{ pkgs, lib, ... }:
{
  gtk.enable = true;
  gtk.iconTheme = lib.mkForce {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  gtk.gtk4.theme = null;
}
