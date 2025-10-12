# /nixos-config/configuration.nix
#
{
  config,
  pkgs,
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
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
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
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [
      "i2c-dev"
      "amdgpu"
    ];
  };

  # nixpkgs.config.permittedInsecurePackages = [
  #   "qtwebengine-5.15.19"
  # ];

  networking = {
    hostName = "fukurowl-pc";
    networkmanager.enable = true;
    extraHosts = "0.0.0.0 apresolve.spotify.com";
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    i2c.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ driversi686Linux.amdvlk ];
    };
    amdgpu = {
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
      initrd.enable = true;
    };
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
      noto-fonts-emoji
    ];
  };

  services = {
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "arto";
      };
    };
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    ddccontrol.enable = true;
    tailscale.enable = true;
  };

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };

  zramSwap.enable = true;

  users.users.arto = {
    isNormalUser = true;
    homeMode = "0700";
    extraGroups = [
      "wheel"
      "networkmanager"
      "i2c"
      "docker"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKMu8p91vFMlCogmKOpImn/0gDpgs3jkKQk9h6Iw3Yj"
    ];
  };

  users.users.yann = {
    isNormalUser = true;
    extraGroups = [
      "users"
      "docker"
      "adbusers"
      "video"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjbRvb1ruMTx3fzyEPuw/gouvLixN/F/dmiN4FIWcOV openpgp:0x4C086962"
    ];
  };

  system.activationScripts.fixDownloadsOwnership = {
    text = ''chown arto:users /home/arto/Downloads'';
    deps = [ "users" ];
  };

  programs = {
    fish.enable = true;
    firefox.enable = true;
    bcc.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };

  virtualisation.docker.enable = true;

  catppuccin = {
    enable = true;
    flavor = "frappe";
    accent = "green";
  };

  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
  };

  system.stateVersion = "25.05";
}
