{ ... }:
{
  programs.plasma = {
    enable = true;

    hotkeys.commands."launch-terminal" = {
      name = "Launch Terminal";
      key = "Ctrl+Alt+T";
      command = "ghostty";
    };

    kwin = {
      effects = {
        dimInactive.enable = true;
        blur.enable = true;
      };
    };

    configFile = {
      # Disable KDE's gtk config kded module — it overwrites home-manager's .gtkrc-2.0 symlink on every login
      kded6rc."Module-gtkconfig".autoload = false;

      kwinrc = {
        Plugins.karouselEnabled = true;
        "Script-karousel" = {
          untileOnDrag = true;
          reMaximize = true;
          resizeNeighborColumn = true;
          presetWidths = "33%, 50%, 66%";
          gapsInnerHorizontal = 8;
          gapsInnerVertical = 8;
          gapsOuterTop = 16;
          gapsOuterBottom = 16;
          gapsOuterLeft = 16;
          gapsOuterRight = 16;
        };
      };
    };

    powerdevil.AC = {
      powerButtonAction = "lockScreen";
      dimDisplay.enable = true;
      dimDisplay.idleTimeout = 300;
      turnOffDisplay.idleTimeout = 600;
      autoSuspend.action = "sleep";
      autoSuspend.idleTimeout = 900;
    };

    session.sessionRestore.restoreOpenApplicationsOnLogin = "onLastLogout";
    windows.allowWindowsToRememberPositions = false;

    shortcuts = {
      kwin = {
        "Toggle Overview" = "Meta+Tab";
        "Window Close" = "Meta+Q";

        # Virtual desktop switching
        "Switch One Desktop to the Left" = "Ctrl+Alt+Left";
        "Switch One Desktop to the Right" = "Ctrl+Alt+Right";

        # Karousel: focus movement
        "karousel-focus-left" = [
          "Meta+H"
          "Meta+Left"
        ];
        "karousel-focus-right" = [
          "Meta+L"
          "Meta+Right"
        ];
        "karousel-focus-up" = [
          "Meta+K"
          "Meta+Up"
        ];
        "karousel-focus-down" = [
          "Meta+J"
          "Meta+Down"
        ];

        # Karousel: move window within column
        "karousel-window-move-left" = [
          "Meta+Shift+H"
          "Meta+Shift+Left"
        ];
        "karousel-window-move-right" = [
          "Meta+Shift+L"
          "Meta+Shift+Right"
        ];
        "karousel-window-move-up" = [
          "Meta+Shift+K"
          "Meta+Shift+Up"
        ];
        "karousel-window-move-down" = [
          "Meta+Shift+J"
          "Meta+Shift+Down"
        ];

        # Karousel: cycle column widths 33/50/66%
        "karousel-cycle-preset-widths" = "Meta+R";

        # Karousel: toggle floating for focused window
        "karousel-window-toggle-floating" = [ "Meta+Space" ];
      };
    };
  };
}
