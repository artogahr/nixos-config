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
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      download-buffer-size = 4194304000;
      max-jobs = "auto";
      cores = 0;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

  };

  boot = {
    loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl."vm.max_map_count" = 2147483642;
  };

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    extraHosts = "0.0.0.0 apresolve.spotify.com";
  };

  hardware.bluetooth = {
    enable = true;
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
    gvfs.enable = true;
    xserver.enable = true;

    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
    };

    tailscale.enable = true;
    flatpak.enable = true;

    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true; # network printer discovery
    };

    syncthing = {
      enable = true;
      user = "arto";
      dataDir = "/home/arto";
    };

    geoclue2 = {
      enable = true;
      enableStatic = true;
      staticLatitude = 50.000;
      staticLongitude = 14.500;
      staticAltitude = 200;
      staticAccuracy = 10000;
    };

    logind.settings.Login = {
      HandlePowerKey = "lock";
      HandlePowerKeyLongPress = "suspend";
    };
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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs = {
    fish.enable = true;
    nix-ld.enable = true;
    firefox.enable = true;
    nh = {
      enable = true;
      flake = "/home/arto/workplace/nixos-config";
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
    };
    dconf.enable = true;
    bcc.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    gamemode.enable = true;
    kdeconnect.enable = true;
  };

  hardware.steam-hardware.enable = true;

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
    podman.enable = true;
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
