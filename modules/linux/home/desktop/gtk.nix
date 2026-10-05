# GTK theming — Linux-only.
{ pkgs, lib, ... }:
{
  gtk.enable = true;
  gtk.iconTheme = lib.mkForce {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  gtk.cursorTheme = {
    name = "catppuccin-frappe-dark-cursors";
    package = pkgs.catppuccin-cursors.frappeDark;
    size = 24;
  };
  gtk.gtk4.theme = null;
}
