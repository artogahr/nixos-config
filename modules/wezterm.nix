# /nixos-config/modules/wezterm.nix
{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.font = wezterm.font "Cascadia Code"

      config.window_background_opacity = 0.8
      config.kde_window_background_blur = true
      config.window_decorations = "NONE"

      config.adjust_window_size_when_changing_font_size = false
      config.hide_tab_bar_if_only_one_tab = true

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
