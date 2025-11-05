{ pkgs, lib, ... }:

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
  imports = (importModules ./modules/common) ++ (importModules ./modules/linux);

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    tree
    anydesk
    gh
    delta
    telegram-desktop
    htop
    ripgrep
    fd
    kdePackages.krohnkite
    openrgb-with-all-plugins
  ];

  programs.home-manager.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  catppuccin.kvantum.enable = true;
  catppuccin.kvantum.apply = true;

  qt.style.name = "kvantum";
  qt.platformTheme.name = "kvantum";

  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    "x-scheme-handler/prusaslicer" = [ "PrusaSlicerURLProtocol.desktop" ];
  };
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/prusaslicer" = [ "PrusaSlicerURLProtocol.desktop" ];
    "text/html" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/about" = [ "firefox.desktop" ];
    "x-scheme-handler/unknown" = [ "firefox.desktop" ];
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
