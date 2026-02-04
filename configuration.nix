# Shared base configuration for all hosts
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./applications.nix
    inputs.dms-plugin-registry.modules.default
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      download-buffer-size = 4194304000;
      max-jobs = 4;
      cores = 2;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    extraHosts = "0.0.0.0 apresolve.spotify.com";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;

    extraConfig.pipewire."99-sensible-settings" = {
      context.properties = {
        resample.quality = 10;
        default.clock.quantum = 1024;
      };
    };
  };

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "Cascadia Code" ];
    };
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  services = {
    udisks2.enable = true;
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      # sddm = {
      #   enable = true;
      #   wayland.enable = true;
      # };
      # sessionPackages = [ pkgs.niri ];
      dms-greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/arto";
      };
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
    };
    tailscale.enable = true;
    geoclue2 = {
      enable = true;
      enableStatic = true;
      staticLatitude = 50.000;
      staticLongitude = 14.500;
      staticAltitude = 200;
      staticAccuracy = 10000;
    };
    dbus.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
    xdgOpenUsePortal = true;
  };

  zramSwap.enable = true;

  users.users.arto = {
    isNormalUser = true;
    homeMode = "0700";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "video"
      "render"
      "storage" # For udisks2: mount/unmount removable media without sudo
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKMu8p91vFMlCogmKOpImn/0gDpgs3jkKQk9h6Iw3Yj"
    ];
  };

  # niri uses xwayland-satellite (not Xwayland directly) for X11 apps; it must be in PATH so niri can set DISPLAY
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  programs = {
    fish.enable = true;
    firefox.enable = true;

    dms-shell = {
      enable = true;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      # enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)

      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

      plugins = {
        dankLauncherKeys.enable = true;
        # dankClight.enable = true; # Disabled - has version incompatibility
        easyEffects.enable = true;
        # dankBatteryAlerts.enable = true;
      };
    };

    niri.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "green";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
