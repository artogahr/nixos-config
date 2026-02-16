{ pkgs, lib, config, desktopShell ? "noctalia", ... }:

let
  importModules =
    dir:
    map (name: dir + "/${name}") (
      builtins.attrNames (
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir dir)
      )
    );
in
{
  imports = (importModules ./modules/common) ++ (importModules ./modules/linux) ++ [ ./mime-associations.nix ];

  home.stateVersion = "25.05";

  home.file."Wallpapers".source = ./wallpapers;

  # EasyEffects output presets (see modules/linux/easyeffects.nix)
  xdg.configFile."easyeffects/output".source = ./presets/easyeffects;

  home.packages = with pkgs; [
    tree
    anydesk
    gh
    delta
    telegram-desktop
    htop
    ripgrep
    fd
    openrgb-with-all-plugins
    libnotify
    papirus-icon-theme
    hicolor-icon-theme
  ] ++ lib.optionals (desktopShell == "plasma") [
    kdePackages.krohnkite
  ];

  programs.home-manager.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  catppuccin.kvantum.enable = true;
  catppuccin.kvantum.apply = true;

  qt.style.name = "kvantum";
  qt.platformTheme.name = "kvantum";

  gtk.enable = true;
  gtk.iconTheme = lib.mkForce {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  gtk.cursorTheme = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    "x-scheme-handler/prusaslicer" = [ "PrusaSlicerURLProtocol.desktop" ];
  };

  xdg.configFile."mimeapps.list".force = true;

  # Noctalia desktop shell (bar, launcher, notifications, lock screen, etc.)
  programs.noctalia-shell = lib.mkIf (desktopShell == "noctalia") {
    enable = true;
    settings.templates.activeTemplates = [
      { id = "niri"; enabled = true; }
      { id = "wezterm"; enabled = true; }
      { id = "ghostty"; enabled = true; }
      { id = "alacritty"; enabled = true; }
      { id = "helix"; enabled = true; }
      { id = "btop"; enabled = true; }
      { id = "yazi"; enabled = true; }
      { id = "discord"; enabled = true; }
      { id = "telegram"; enabled = true; }
    ];
  };

  # Niri keybindings for Noctalia shell integration
  xdg.configFile."niri/noctalia-keybinds.kdl" = lib.mkIf (desktopShell == "noctalia") {
    text = ''
    binds {
        // Application Launcher and Control Center
        Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+S { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
        Mod+N { spawn "noctalia-shell" "ipc" "call" "notifications" "toggleHistory"; }
        Mod+V { spawn "noctalia-shell" "ipc" "call" "launcher" "clipboard"; }

        // Screenshots (niri native)
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        // Lock screen
        Mod+Alt+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

        // Session menu (logout, reboot, shutdown, suspend)
        Mod+Shift+Escape { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }

        // Quit niri
        Ctrl+Alt+Delete { quit; }

        // Volume controls via Noctalia (provides OSD)
        XF86AudioRaiseVolume { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86AudioMute { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }
        XF86AudioMicMute { spawn "noctalia-shell" "ipc" "call" "volume" "muteInput"; }

        // Brightness controls via Noctalia (provides OSD)
        XF86MonBrightnessUp { spawn "noctalia-shell" "ipc" "call" "brightness" "increase"; }
        XF86MonBrightnessDown { spawn "noctalia-shell" "ipc" "call" "brightness" "decrease"; }
    }

    switch-events {
        // Lid close - lock and suspend via Noctalia
        lid-close { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "lockAndSuspend"; }
    }
  '';
  };

  # Ensure noctalia.kdl exists before niri parses its config (noctalia overwrites it at runtime)
  home.activation.ensureNoctaliaNiriTheme = lib.mkIf (desktopShell == "noctalia") (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.config/niri/noctalia.kdl" ]; then
        $DRY_RUN_CMD mkdir -p "$HOME/.config/niri"
        $DRY_RUN_CMD touch "$HOME/.config/niri/noctalia.kdl"
      fi
    ''
  );

  # Include Noctalia keybindings and generated theme colors in niri config
  xdg.configFile."niri/config.kdl".text = lib.mkAfter (lib.optionalString (desktopShell == "noctalia") ''
    spawn-at-startup "noctalia-shell"
    include "noctalia-keybinds.kdl"
    include "noctalia.kdl"
  '');

  xdg.desktopEntries.PrusaSlicerURLProtocol = {
    name = "PrusaSlicer URL Protocol";
    exec = "${pkgs.prusa-slicer}/bin/prusa-slicer --single-instance %u";
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/prusaslicer" ];
    noDisplay = true;
  };
}
