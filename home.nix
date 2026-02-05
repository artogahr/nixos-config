{ pkgs, lib, config, desktopShell ? "dms", ... }:

let
  importModules =
    dir:
    map (name: dir + "/${name}") (
      builtins.attrNames (
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir dir)
      )
    );

  # Lock then suspend (used by dms.kdl lid-close and power actions)
  dms-suspend = pkgs.writeShellScript "dms-suspend" ''
    dms ipc call lock lock
    sleep 0.5
    systemctl suspend
  '';

  # Suspend with 5s confirmation (Mod+Shift+Escape in dms.kdl)
  suspend-dialog = pkgs.writeShellScript "dms-suspend-dialog" ''
    if ${pkgs.libnotify}/bin/notify-send -u critical -t 5000 "Suspend?" "System will suspend in 5 seconds. Click to cancel."; then
      sleep 5
      ${dms-suspend}
    fi
  '';
in
{
  imports = (importModules ./modules/common) ++ (importModules ./modules/linux);

  home.stateVersion = "25.05";

  home.file."Wallpapers".source = ./wallpapers;

  home.packages = with pkgs; [
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
  ] ++ lib.optionals (desktopShell == "plasma") [ kdePackages.krohnkite ];

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
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/prusaslicer" = [ "PrusaSlicerURLProtocol.desktop" ];
    "text/html" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/about" = [ "firefox.desktop" ];
    "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    "inode/directory" = [ "org.kde.dolphin.desktop" ];
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

  # Niri keybindings for DMS (spotlight, lock, screenshots, audio, lid-close)
  xdg.configFile."niri/dms.kdl" = lib.mkIf (desktopShell == "dms") {
    text = ''
    binds {
        // DMS Application Launcher and Notification Center
        Mod+Space { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
        Mod+N { spawn "dms" "ipc" "call" "notifications" "toggle"; }

        // Screenshots - use DMS screenshot (opens in editor for annotation)
        Print { spawn "dms" "ipc" "call" "niri" "screenshot"; }
        Ctrl+Print { spawn "dms" "ipc" "call" "niri" "screenshotScreen"; }
        Alt+Print { spawn "dms" "ipc" "call" "niri" "screenshotWindow"; }
        Shift+Print { spawn "dms" "ipc" "call" "niri" "screenshotWindow"; }

        // Lock - use DMS lock
        Mod+Alt+L { spawn "dms" "ipc" "call" "lock" "lock"; }

        // Power actions - Suspend with confirmation
        Mod+Shift+Escape { spawn "${suspend-dialog}"; }

        // Quit niri (shows confirmation)
        Ctrl+Alt+Delete { quit; }

        // Audio controls via DMS IPC
        XF86AudioMute { spawn "dms" "ipc" "call" "audio" "mute"; }
        XF86AudioMicMute { spawn "dms" "ipc" "call" "audio" "micmute"; }
    }

    switch-events {
        // Lid close - lock then suspend
        lid-close { spawn "${dms-suspend}"; }
    }
  '';
  };

  # Include DMS keybindings in main niri config when using DMS
  xdg.configFile."niri/config.kdl".text = lib.mkAfter (lib.optionalString (desktopShell == "dms") ''
    include "dms.kdl"
  '');

  xdg.desktopEntries.PrusaSlicerURLProtocol = {
    name = "PrusaSlicer URL Protocol";
    exec = "${pkgs.prusa-slicer}/bin/prusa-slicer --single-instance %u";
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/prusaslicer" ];
    noDisplay = true;
  };
}
