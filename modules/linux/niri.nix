# Niri - scrollable tiling Wayland compositor
{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg.configFile."niri/config.kdl".text = ''
    input {
        touchpad {
            tap
            natural-scroll
        }

        trackpoint {
            accel-speed 0.3
            accel-profile "flat"
        }
    }

    output "eDP-1" {
        scale 1.0
    }

    output "DP-5" {
        scale 1.0
    }

    window-rule {
        clip-to-geometry true
        geometry-corner-radius 12
        draw-border-with-background false
    }

    spawn-at-startup "sway-audio-idle-inhibit"

    screenshot-path "~/Pictures/Screenshots/Screenshot-%Y-%m-%d-%H-%M-%S.png"

    cursor {
        xcursor-theme "${config.gtk.cursorTheme.name}"
        xcursor-size ${toString config.gtk.cursorTheme.size}
    }

    binds {
        Mod+Return { spawn "wezterm"; }

        Mod+A { spawn "pwvucontrol"; }
        Mod+P { spawn "wdisplays"; }
        Mod+Q { close-window; }

        Mod+Left { focus-column-or-monitor-left; }
        Mod+Down { focus-window-or-workspace-down; }
        Mod+Up { focus-window-or-workspace-up; }
        Mod+Right { focus-column-or-monitor-right; }
        Mod+H { focus-column-or-monitor-left; }
        Mod+J { focus-window-or-workspace-down; }
        Mod+K { focus-window-or-workspace-up; }
        Mod+L { focus-column-or-monitor-right; }

        Mod+Shift+Left { move-column-left-or-to-monitor-left; }
        Mod+Shift+Down { move-window-down-or-to-workspace-down; }
        Mod+Shift+Up { move-window-up-or-to-workspace-up; }
        Mod+Shift+Right { move-column-right-or-to-monitor-right; }
        Mod+Shift+H { move-column-left-or-to-monitor-left; }
        Mod+Shift+J { move-window-down-or-to-workspace-down; }
        Mod+Shift+K { move-window-up-or-to-workspace-up; }
        Mod+Shift+L { move-column-right-or-to-monitor-right; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        Mod+R { switch-preset-column-width; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        Mod+Comma { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }
        Mod+BracketLeft { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        Mod+Shift+Space { toggle-window-floating; }
        Mod+Tab { toggle-overview; }
    }
  '';

  home.packages = with pkgs; [
    nirius
    brightnessctl
    wdisplays
    wl-gammactl
    wlr-randr
    sway-audio-idle-inhibit

    shared-mime-info
    desktop-file-utils

    nautilus
    loupe
    papers
  ];
}
