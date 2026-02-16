# Shared base configuration for all hosts
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./applications.nix
    ./desktop-shell.nix
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
    # Display manager, compositor, and desktop shell driven by desktop.shell (see desktop-shell.nix)

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

    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandlePowerKey = "lock";
      HandlePowerKeyLongPress = "suspend";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals =
      if config.desktop.shell == "plasma"
      then [ pkgs.kdePackages.xdg-desktop-portal-kde ]
      else [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
  };

  systemd.user.services.plasma-xdg-desktop-portal-kde = lib.mkIf (config.desktop.shell == "plasma") {
    enable = true;
    wantedBy = [ "graphical-session.target" ];
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
      "storage" # udisks2: mount/unmount removable media without sudo
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKMu8p91vFMlCogmKOpImn/0gDpgs3jkKQk9h6Iw3Yj"
    ];
  };

  # niri uses xwayland-satellite for X11 apps; must be in PATH so niri can set DISPLAY
  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.catppuccin-cursors.mochaDark
  ];


  programs = {
    fish.enable = true;
    firefox.enable = true;
    dconf.enable = true;
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
    cursors.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
