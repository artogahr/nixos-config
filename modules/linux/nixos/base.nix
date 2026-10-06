# NixOS-wide base configuration shared by all Linux hosts, desktop or headless.
# Desktop-only settings live in ./desktop, which only the graphical hosts import.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
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
  };

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
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
    openssh.authorizedKeys.keys = with import ../../../ssh-keys.nix; [
      legacy
      macbook
      phone
    ];
  };

  programs = {
    fish.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      flake = "/home/arto/workplace/nixos-config";
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
    };
    mosh.enable = true;
    bcc.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "green";
    # The tty module reads the palette out of a derivation, which breaks evaluating
    # this host from a non-Linux machine. Same colours, inlined from catppuccin
    # palette rev 07d02aa (mocha), in the order its tty.nix uses.
    tty.enable = false;
  };

  console.colors = [
    "1e1e2e" # base
    "f38ba8" # red
    "a6e3a1" # green
    "f9e2af" # yellow
    "89b4fa" # blue
    "f5c2e7" # pink
    "94e2d5" # teal
    "bac2de" # subtext1
    "585b70" # surface2
    "f38ba8" # red
    "a6e3a1" # green
    "f9e2af" # yellow
    "89b4fa" # blue
    "f5c2e7" # pink
    "94e2d5" # teal
    "a6adc8" # subtext0
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
