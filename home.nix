{
  pkgs,
  lib,
  config,
  ...
}:

let
  importModules =
    dir:
    map (name: dir + "/${name}") (
      builtins.attrNames (
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir dir)
      )
    );
in
{
  imports =
    (importModules ./modules/common) ++ (importModules ./modules/linux) ++ [ ./mime-associations.nix ];

  home.stateVersion = "25.05";

  home.file."Wallpapers".source = ./wallpapers;

  # EasyEffects output presets (see modules/linux/easyeffects.nix)
  xdg.configFile."easyeffects/output".source = ./presets/easyeffects;

  home.packages =
    with pkgs;
    [
      tree
      anydesk
      gh
      delta
      telegram-desktop
      htop
      ripgrep
      fd
      easyeffects
      libnotify
      papirus-icon-theme
      hicolor-icon-theme
      kdePackages.karousel
    ];

  programs.home-manager.enable = true;
  programs.mangohud.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  catppuccin.kvantum.enable = true;
  catppuccin.kvantum.apply = true;

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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    "x-scheme-handler/prusaslicer" = [ "PrusaSlicerURLProtocol.desktop" ];
  };

  xdg.configFile."mimeapps.list".force = true;

  xdg.desktopEntries.PrusaSlicerURLProtocol = {
    name = "PrusaSlicer URL Protocol";
    exec = "${pkgs.prusa-slicer}/bin/prusa-slicer --single-instance %u";
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/prusaslicer" ];
    noDisplay = true;
  };
}
