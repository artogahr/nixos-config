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
    kwin.effects.dimInactive.enable = true;
    kwin.effects.blur.enable = true;
    powerdevil.AC = {
      powerButtonAction = "sleep";
      dimDisplay.enable = true;
      dimDisplay.idleTimeout = 300;
      autoSuspend.action = "sleep";
      autoSuspend.idleTimeout = 600;
    };
  };
}
