{
  config,
  pkgs,
  lib,
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
  };
}
