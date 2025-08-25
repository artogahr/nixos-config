{ pkgs, lib, ... }:

{
  imports = map (name: ./modules + "/${name}") (
    builtins.attrNames (
      lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
        builtins.readDir ./modules
      )
    )
  );

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
  };

  xdg.desktopEntries.PrusaSlicerURLProtocol = {
    name = "PrusaSlicer URL Protocol";
    exec = "${pkgs.prusa-slicer}/bin/prusa-slicer --single-instance %u";
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/prusaslicer" ];
    noDisplay = true;
  };
}
