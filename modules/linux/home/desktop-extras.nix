# Linux desktop extras: wallpapers, easyeffects presets, Linux-only home packages, KDE quirks.
{ pkgs, lib, ... }:
{
  home.file."Wallpapers".source = ../../../wallpapers;

  # EasyEffects output presets (see ./easyeffects.nix)
  xdg.configFile."easyeffects/output".source = ../../../presets/easyeffects;

  home.packages = with pkgs; [
    anydesk
    easyeffects
    libnotify
    papirus-icon-theme
    hicolor-icon-theme
    kdePackages.karousel
    telegram-desktop
  ];

  catppuccin.kvantum.enable = true;
  catppuccin.kvantum.apply = true;

  # KDE's gtkconfig kded module writes .gtkrc-2.0 as a plain file on every session start,
  # conflicting with home-manager's symlink. Remove it before HM checks link targets.
  home.activation.removeKdeGtkrc = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "$HOME/.gtkrc-2.0"
  '';

  programs.mangohud.enable = true;
}
