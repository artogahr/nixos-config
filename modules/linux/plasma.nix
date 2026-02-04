# Only active when desktop.shell == "plasma" (see desktop-shell.nix).
{ desktopShell, lib, ... }:
lib.mkIf (desktopShell == "plasma") {
  programs.plasma = {
    enable = true;

    hotkeys.commands."launch-terminal" = {
      name = "Launch Terminal";
      key = "Ctrl+Alt+T";
      command = "wezterm";
    };
    kwin = {
      effects = {
        dimInactive.enable = true;
        blur.enable = true;
      };
    };

    configFile = {
      kwinrc = {
        Plugins = {
          krohnkiteEnabled = true;
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
        "Switch One Desktop Up" = "Meta+Ctrl+Left";
        "Switch One Desktop Down" = "Meta+Ctrl+Right";
      };
    };
  };
}
