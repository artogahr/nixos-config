# Niri - scrollable tiling Wayland compositor
# Simple setup that keeps KDE apps and utilities
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Niri config file
  xdg.configFile."niri/config.kdl".text = ''
        // TODO: set optional=true once it's released
        include  "dms/alttab.kdl"
        include  "dms/binds.kdl"
        include  "dms/colors.kdl"
        include  "dms/cursor.kdl"
        include  "dms/layout.kdl"
        include  "dms/outputs.kdl"
        include  "dms/windowrules.kdl"
        include  "dms/wpblur.kdl"

        input {
        //     keyboard {
        //         xkb {
        //             layout "us"
        //         }
        //     }
        //     
            touchpad {
                tap
                natural-scroll
            }
            
            trackpoint {
                accel-speed 0.3
                accel-profile "flat"
            }
        }

    //    layout {
    //        gaps 8
    //        
    //        border {
    //            width 2
    //            active-color "#a6e3a1"
    //            inactive-color "#45475a"
    //        }
    //        
    //        focus-ring {
    //            width 2
    //            active-color "#a6e3a1"
    //            inactive-color "#45475a"
    //        }
    //    }
    //
    //  window-rule {
    //      clip-to-geometry true
    //      geometry-corner-radius 12
    //      draw-border-with-background false
    //  }

        // spawn-at-startup "swaybg" "-i" "${../../wallpapers/art-institute-of-chicago-18pvW-EQmkQ-unsplash.jpg}" "-m" "fill"
        // spawn-at-startup "waybar"
        // spawn-at-startup "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        // spawn-at-startup "swaync"
        // spawn-at-startup "nm-applet" "--indicator"
        // spawn-at-startup "blueman-applet"
        spawn-at-startup "sway-audio-idle-inhibit"

        screenshot-path "~/Pictures/Screenshots/Screenshot-%Y-%m-%d-%H-%M-%S.png"

        // cursor {
        //     xcursor-theme "${config.gtk.cursorTheme.name}"
        //     xcursor-size ${toString config.gtk.cursorTheme.size}
        // }

        binds {
            Mod+Return { spawn "wezterm"; }
            
            XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
            XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
            Mod+A { spawn "pwvucontrol"; }
            Mod+P { spawn "wdisplays"; }
            Mod+Q { close-window; }
            Mod+V { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
            XF86MonBrightnessUp { spawn "brightnessctl" "set" "+5%"; }
            XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
            
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

            // DMS Application Launcher and Notification Center
            Mod+Space { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
            Mod+N { spawn "dms" "ipc" "call" "notifications" "toggle"; }

            // Screenshots - use DMS screenshot (opens in editor for annotation)
            Print { spawn "dms" "ipc" "call" "niri" "screenshot"; }
            Ctrl+Print { spawn "dms" "ipc" "call" "niri" "screenshotScreen"; }
            Alt+Print { spawn "dms" "ipc" "call" "niri" "screenshotWindow"; }
            Shift+Print { spawn "dms" "ipc" "call" "niri" "screenshotWindow"; }

            // Lock - use DMS lock
            Mod+Alt+L { spawn "dms" "ipc" "call" "lock" "lock"; }

            // Quit niri (shows confirmation)
            Ctrl+Alt+Delete { quit; }

            // Audio controls via DMS IPC
            XF86AudioMute { spawn "dms" "ipc" "call" "audio" "mute"; }
            XF86AudioMicMute { spawn "dms" "ipc" "call" "audio" "micmute"; }
        }
  '';

  home.packages = with pkgs; [
    niri
    nirius
    waybar
    swaynotificationcenter
    brightnessctl
    networkmanagerapplet
    blueman
    wl-clipboard
    cliphist
    wdisplays
    wl-gammactl
    wlr-randr
    swaybg
    sway-audio-idle-inhibit

    shared-mime-info
    desktop-file-utils

    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.kate
    kdePackages.kservice
  ];
}
