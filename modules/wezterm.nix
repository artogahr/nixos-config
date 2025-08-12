# /nixos-config/modules/wezterm.nix
{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.font = wezterm.font("Cascadia Code", {
        harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
      })

      config.window_background_opacity = 0.85
      config.window_decorations = "RESIZE"

      config.adjust_window_size_when_changing_font_size = false
      config.window_padding = {
        left = 10,
        right = 10,
        top = 10,
        bottom = 10,
      }

      config.color_scheme = "Catppuccin Macchiato"

      return config
    '';
  };
}
