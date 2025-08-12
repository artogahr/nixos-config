{ pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = lib.mkForce "catppuccin-mocha-transparent";
    };
    themes = {
      "catppuccin-mocha-transparent" = {
        # Inherit all other styles from the original catppuccin-mocha theme
        inherits = "catppuccin-mocha";
        # Set the UI background to be transparent by leaving it empty
        "ui.background" = { };
      };
    };
  };
}
