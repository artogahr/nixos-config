{ ... }:
{
  programs.plasma = {
    enable = true;

    kwin = {
      effects = {
        dimInactive.enable = true;
        blur.enable = true;
      };
    };

    configFile = {
      # Disable KDE's gtk config kded module — it overwrites home-manager's .gtkrc-2.0 symlink on every login
      kded6rc."Module-gtkconfig".autoload = false;
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
  };
}
