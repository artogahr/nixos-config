{
  pkgs,
  lib,
  config,
  desktopShell ? "dms",
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
      openrgb-with-all-plugins
      easyeffects
      libnotify
      papirus-icon-theme
      hicolor-icon-theme
    ]
    ++ lib.optionals (desktopShell == "plasma") [ kdePackages.krohnkite ];

  programs.home-manager.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  catppuccin.kvantum.enable = true;
  catppuccin.kvantum.apply = true;

  qt.style.name = "kvantum";
  qt.platformTheme.name = "kvantum";

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

  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    "x-scheme-handler/prusaslicer" = [ "PrusaSlicerURLProtocol.desktop" ];
  };

  xdg.configFile."mimeapps.list".force = true;

  # DMS default settings (used if settings.json doesn't exist; editable via DMS settings UI)
  xdg.configFile."DankMaterialShell/default-settings.json" = lib.mkIf (desktopShell == "dms") {
    text = builtins.toJSON {
      acMonitorTimeout = 300;
      acLockTimeout = 300;
      lockBeforeSuspend = true;
      lockScreenShowPowerActions = true;
      loginctlLockIntegration = true;
      fadeToLockEnabled = true;
      fadeToLockGracePeriod = 5;
      showWorkspaceIndex = true;
      showWorkspacePadding = true;
      showWorkspaceApps = true;
      showOccupiedWorkspacesOnly = true;
      showDock = false;
      dockAutoHide = true;
      dockGroupByApp = false;
      dockOpenOnOverview = true;
      dockIconsize = 24;
      osdPowerProfileEnabled = true;
      customAnimationDuration = 100;
      visible = true;
      autoHide = false;
      autoHideDelay = 250;
      openOnOverview = false;
    };
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
