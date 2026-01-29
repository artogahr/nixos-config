{ pkgs, lib, config, ... }:

let
  importModules =
    dir:
    map (name: dir + "/${name}") (
      builtins.attrNames (
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir dir)
      )
    );

  # Script to lock screen then suspend (with dialog confirmation)
  dms-suspend = pkgs.writeShellScript "dms-suspend" ''
    dms ipc call lock lock
    sleep 0.5
    systemctl suspend
  '';

  # Simple confirmation dialog for suspend
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

  # Wallpapers directory reference
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
    kdePackages.krohnkite
    openrgb-with-all-plugins
    easyeffects # For audio effects management
    libnotify # For suspend dialog notifications
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

  # DMS default settings for power/lock configuration
  # These will be used by DMS if settings.json doesn't exist
  # You can modify these through the DMS settings UI after first run
  xdg.configFile."DankMaterialShell/default-settings.json".text = builtins.toJSON {
    # Power/Lock screen
    acMonitorTimeout = 300; # Lock after 5 minutes (300 seconds)
    acLockTimeout = 300; # Lock timeout
    lockBeforeSuspend = true; # Lock before suspending
    lockScreenShowPowerActions = true; # Show power actions on lock screen
    loginctlLockIntegration = true; # Integrate with loginctl lock
    fadeToLockEnabled = true; # Fade to lock screen
    fadeToLockGracePeriod = 5; # Grace period before fade (seconds)
    
    # Workspaces
    showWorkspaceIndex = true;
    showWorkspacePadding = true;
    showWorkspaceApps = true;
    showOccupiedWorkspacesOnly = true;
    
    # Dock
    showDock = false;
    dockAutoHide = true;
    dockGroupByApp = false;
    dockOpenOnOverview = true;
    dockIconsize = 24;
    
    # On Screen Display
    osdPowerProfileEnabled = true;
    
    # Animation
    customAnimationDuration = 100;
    
    # Behavior
    visible = true;
    autoHide = false;
    autoHideDelay = 250;
    openOnOverview = false;
  };

  # Niri DMS keybindings - separate file for organization
  xdg.configFile."niri/dms.kdl".text = ''
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
  
  # Include DMS keybindings in main niri config
  xdg.configFile."niri/config.kdl".text = lib.mkAfter ''
    include "dms.kdl"
  '';

  xdg.desktopEntries.PrusaSlicerURLProtocol = {
    name = "PrusaSlicer URL Protocol";
    exec = "${pkgs.prusa-slicer}/bin/prusa-slicer --single-instance %u";
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/prusaslicer" ];
    noDisplay = true;
  };
}
