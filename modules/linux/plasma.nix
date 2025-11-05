{
  ...
}:

{
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
      powerButtonAction = "nothing";
      dimDisplay.enable = true;
      dimDisplay.idleTimeout = 120;
      turnOffDisplay.idleTimeout = 300;
      autoSuspend.action = "nothing";
      #autoSuspend.idleTimeout = 600;
    };

    session.sessionRestore.restoreOpenApplicationsOnLogin = "onLastLogout";
    windows.allowWindowsToRememberPositions = true;

    shortcuts = {
      kwin = {
        "Toggle Overview" = "Meta+Tab";
        "Switch One Desktop Up" = "Meta+Ctrl+Left";
        "Switch One Desktop Down" = "Meta+Ctrl+Right";
      };
    };
  };
}
