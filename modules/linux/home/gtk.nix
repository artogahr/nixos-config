# GTK theming — Linux-only.
{ pkgs, lib, ... }:
{
  gtk.enable = true;
  gtk.iconTheme = lib.mkForce {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  gtk.cursorTheme = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
  };
  gtk.gtk4.theme = null;
}
