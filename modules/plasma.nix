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
    powerdevil.AC = {
      powerButtonAction = "sleep";
      dimDisplay.enable = true;
      dimDisplay.idleTimeout = 300;
      autoSuspend.action = "sleep";
      autoSuspend.idleTimeout = 600;
    };
    session.sessionRestore.restoreOpenApplicationsOnLogin = "whenSessionWasManuallySaved";
    windows.allowWindowsToRememberPositions = true;
    shortcuts = {
      kwin = {
        "Toggle Overview" = "Meta+Tab";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
        "Close Window" = "Meta+Q";
        "Move Window Left" = "Meta+Left";
        "Quick Tile Window to the Right" = "Meta+Right";
        "Quick Tile Window to the Left" = "Meta+Left";
        "Quick Tile Window to the Top" = "Meta+Up";
        "Quick Tile Window to the Down" = "Meta+Down";
        "Move Window to the Center" = "Meta+C";
        "Move Window One Screen Down" = "Meta+Shift+Down";
        "Move Window One Screen Up" = "Meta+Shift+Up";
        "Switch One Desktop Up" = "Meta+Ctrl+Left";
        "Switch One Desktop Down" = "Meta+Ctrl+Right";
      };
    };
  };
}
