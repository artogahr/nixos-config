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

        output "eDP-1" {
            scale 1.0
        }

        output "DP-5" {
            scale 1.0
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
    //    window-rule {
    //        clip-to-geometry true
    //        geometry-corner-radius 12
    //        draw-border-with-background false
    //    }

        // spawn-at-startup "swaybg" "-i" "${../../wallpapers/art-institute-of-chicago-18pvW-EQmkQ-unsplash.jpg}" "-m" "fill"
        // spawn-at-startup "waybar"
        // spawn-at-startup "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        // spawn-at-startup "swaync"
        // spawn-at-startup "nm-applet" "--indicator"
        // spawn-at-startup "blueman-applet"

        screenshot-path "~/Pictures/Screenshots/Screenshot-%Y-%m-%d-%H-%M-%S.png"

        binds {
            Mod+Return { spawn "wezterm"; }
            
            XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
            XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
            Mod+A { spawn "pwvucontrol"; }
            Mod+P { spawn "wdisplays"; }
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
        }
  '';

  # Waybar - modern pill-style config
  # programs.waybar = {
  #   enable = true;
  #   settings.mainBar = {
  #     layer = "top";
  #     position = "top";
  #     height = 38;
  #     spacing = 2;
  #     margin-top = 6;
  #     margin-bottom = 0;
  #     margin-left = 10;
  #     margin-right = 10;
  #
  #     modules-left = [
  #       "niri/workspaces"
  #       "niri/window"
  #     ];
  #     modules-center = [ "clock" ];
  #     modules-right = [
  #       "pulseaudio"
  #       "network"
  #       "backlight"
  #       "battery"
  #       "tray"
  #     ];
  #
  #     "niri/workspaces" = {
  #       all-outputs = false;
  #     };
  #
  #     "niri/window" = {
  #       format = "{}";
  #       max-length = 50;
  #       rewrite = {
  #         "(.*) — Mozilla Firefox" = "󰈹  $1";
  #         "(.*) - Visual Studio Code" = "󰨞  $1";
  #         "(.*)Spotify" = "󰓇  $1";
  #         "(.*) - Discord" = "󰙯  $1";
  #       };
  #     };
  #
  #     clock = {
  #       format = "{:%H:%M  %a %d %b}";
  #       tooltip-format = "<tt><small>{calendar}</small></tt>";
  #       calendar = {
  #         mode = "month";
  #         mode-mon-col = 3;
  #         weeks-pos = "right";
  #         on-scroll = 1;
  #         format = {
  #           months = "<span color='#a6e3a1'><b>{}</b></span>";
  #           days = "<span color='#cdd6f4'><b>{}</b></span>";
  #           weeks = "<span color='#89b4fa'><b>W{}</b></span>";
  #           weekdays = "<span color='#f9e2af'><b>{}</b></span>";
  #           today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
  #         };
  #       };
  #       actions = {
  #         on-click-right = "mode";
  #         on-scroll-up = "shift_up";
  #         on-scroll-down = "shift_down";
  #       };
  #     };
  #
  #     battery = {
  #       states = {
  #         warning = 30;
  #         critical = 15;
  #       };
  #       format = "{icon}  {capacity}%";
  #       format-charging = "󰂄  {capacity}%";
  #       format-plugged = "󰚥  {capacity}%";
  #       format-icons = [
  #         "󰁺"
  #         "󰁻"
  #         "󰁼"
  #         "󰁽"
  #         "󰁾"
  #         "󰁿"
  #         "󰂀"
  #         "󰂁"
  #         "󰂂"
  #         "󰁹"
  #       ];
  #       tooltip-format = "{timeTo}\n{power}W";
  #     };
  #
  #     pulseaudio = {
  #       format = "{icon}  {volume}%";
  #       format-muted = "󰝟  Muted";
  #       format-icons = {
  #         headphone = "󰋋";
  #         hands-free = "󱡏";
  #         headset = "󰋎";
  #         phone = "";
  #         portable = "";
  #         car = "";
  #         default = [
  #           "󰕿"
  #           "󰖀"
  #           "󰕾"
  #         ];
  #       };
  #       on-click = "pwvucontrol";
  #       on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
  #       scroll-step = 5;
  #     };
  #
  #     network = {
  #       format-wifi = "󰤨  {essid}";
  #       format-ethernet = "󰈀  Wired";
  #       format-disconnected = "󰤭  Offline";
  #       tooltip-format-wifi = "{signalStrength}% • {ipaddr}";
  #       tooltip-format-ethernet = "{ipaddr}";
  #       on-click = "nm-connection-editor";
  #     };
  #
  #     backlight = {
  #       format = "󰃠  {percent}%";
  #       on-scroll-up = "brightnessctl set +5%";
  #       on-scroll-down = "brightnessctl set 5%-";
  #     };
  #
  #     tray = {
  #       spacing = 10;
  #     };
  #   };
  #
  #   style = ''
  #     * {
  #       font-family: "Cascadia Code", "Font Awesome 6 Free", "Font Awesome 6 Brands";
  #       font-size: 15px;
  #       font-weight: 600;
  #       border: none;
  #       border-radius: 0;
  #       min-height: 0;
  #     }
  #
  #     window#waybar {
  #       background: transparent;
  #     }
  #
  #     /* Pill-shaped modules with transparency */
  #     #workspaces,
  #     #window,
  #     #clock,
  #     #tray,
  #     #pulseaudio,
  #     #network,
  #     #backlight,
  #     #battery {
  #       background: rgba(30, 30, 46, 0.75);
  #       padding: 6px 16px;
  #       margin: 0 3px;
  #       border-radius: 20px;
  #       color: #cdd6f4;
  #       border: 2px solid rgba(69, 71, 90, 0.5);
  #       transition: all 0.3s ease;
  #     }
  #
  #     #workspaces {
  #       padding: 6px 5px;
  #     }
  #
  #     #workspaces button {
  #       padding: 0 12px;
  #       color: #6c7086;
  #       border-radius: 16px;
  #       transition: all 0.3s ease;
  #       font-size: 18px;
  #       font-weight: 700;
  #     }
  #
  #     #workspaces button.active {
  #       color: #a6e3a1;
  #       background: rgba(166, 227, 161, 0.15);
  #     }
  #
  #     #workspaces button:hover {
  #       color: #cdd6f4;
  #       background: rgba(205, 214, 244, 0.1);
  #     }
  #
  #     /* Icons and text sizing */
  #     #pulseaudio,
  #     #network,
  #     #backlight,
  #     #battery {
  #       font-size: 15px;
  #     }
  #
  #     #window {
  #       color: #a6e3a1;
  #     }
  #
  #     #clock {
  #       color: #89b4fa;
  #       font-weight: 700;
  #       font-size: 16px;
  #     }
  #
  #     #battery {
  #       color: #a6e3a1;
  #     }
  #
  #     #battery.warning {
  #       color: #f9e2af;
  #     }
  #
  #     #battery.critical {
  #       color: #f38ba8;
  #     }
  #
  #     #battery.charging {
  #       color: #a6e3a1;
  #     }
  #
  #     #pulseaudio {
  #       color: #f9e2af;
  #     }
  #
  #     #pulseaudio.muted {
  #       color: #6c7086;
  #     }
  #
  #     #network {
  #       color: #89dceb;
  #     }
  #
  #     #network.disconnected {
  #       color: #6c7086;
  #     }
  #
  #     #backlight {
  #       color: #f9e2af;
  #     }
  #
  #     #tray {
  #       padding: 4px 10px;
  #     }
  #
  #     #tray > .passive {
  #       -gtk-icon-effect: dim;
  #     }
  #
  #     #tray > .needs-attention {
  #       -gtk-icon-effect: highlight;
  #       color: #f38ba8;
  #     }
  #
  #     /* Hover effects for all modules */
  #     #clock:hover,
  #     #pulseaudio:hover,
  #     #network:hover,
  #     #backlight:hover,
  #     #battery:hover {
  #       background: rgba(30, 30, 46, 0.9);
  #       border-color: rgba(166, 227, 161, 0.8);
  #     }
  #
  #     tooltip {
  #       background: rgba(30, 30, 46, 0.95);
  #       border: 2px solid #45475a;
  #       border-radius: 12px;
  #       color: #cdd6f4;
  #       padding: 10px;
  #     }
  #
  #     tooltip label {
  #       color: #cdd6f4;
  #     }
  #   '';
  # };
  #
  # Swaync config
  # xdg.configFile."swaync/config.json".text = builtins.toJSON {
  #   positionX = "right";
  #   positionY = "top";
  #   control-center-width = 500;
  #   control-center-height = 600;
  #   timeout = 10;
  #   timeout-low = 5;
  #   timeout-critical = 0;
  #   widgets = [
  #     "title"
  #     "dnd"
  #     "notifications"
  #   ];
  # };
  #
  # xdg.configFile."swaync/style.css".text = ''
  #   * { font-family: "Cascadia Code", monospace; }
  #   .control-center { background: #1e1e2e; border: 2px solid #45475a; border-radius: 8px; }
  #   .notification { background: #1e1e2e; border: 2px solid #45475a; border-radius: 8px; padding: 8px; margin: 8px; }
  #   .notification .close-button { background: #f38ba8; color: #1e1e2e; border-radius: 4px; }
  # '';

  # # Niriswitcher - app switcher for niri
  # programs.niriswitcher = {
  #   enable = true;
  #   settings = {
  #     # You can customize this later if needed
  #     # See: https://github.com/isaksamsten/niriswitcher?tab=readme-ov-file#options
  #   };
  # };

  # # KDE Connect
  # services.kdeconnect = {
  #   enable = true;
  #   indicator = true;
  # };

  # # Anyrun - modern app launcher
  # programs.anyrun = {
  #   enable = true;
  #   config = {
  #     plugins = [
  #       "${pkgs.anyrun}/lib/libapplications.so"
  #       "${pkgs.anyrun}/lib/libshell.so"
  #       "${pkgs.anyrun}/lib/librink.so"
  #       "${pkgs.anyrun}/lib/libsymbols.so"
  #     ];
  #     width.fraction = 0.3;
  #     hideIcons = false;
  #     ignoreExclusiveZones = false;
  #     layer = "overlay";
  #     hidePluginInfo = true;
  #     closeOnClick = true;
  #   };
  # };

  # Packages
  home.packages = with pkgs; [
    niri
    nirius # Utility commands for niri
    waybar
    swaynotificationcenter
    brightnessctl
    networkmanagerapplet
    blueman
    wl-clipboard
    cliphist
    wdisplays # GUI for display management (like monitor settings)
    wl-gammactl # Gamma control for Wayland
    wlr-randr # Control outputs (brightness, gamma, etc)
    swaybg # Wallpaper setter

    # KDE apps (work great in Niri)
    kdePackages.dolphin
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.kate
  ];
}
