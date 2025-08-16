# /nixos-config/configuration.nix
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Core NixOS Settings
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  # Bootloader and Kernel
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [
    "i2c-dev"
    "amdgpu"
  ];
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  # Networking
  networking.hostName = "fukurowl-pc";
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  hardware.i2c.enable = true;
  hardware.amdgpu.overdrive.enable = true;
  hardware.amdgpu.overdrive.ppfeaturemask = "0xffffffff";
  hardware.amdgpu.initrd.enable = true;

  # Time, Locale, and Fonts
  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Cascadia Code" ];
        # sansSerif = [ "Noto Sans" ];
        # serif = [ "Noto Serif" ];
      };
    };
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };
  # Desktop Environment: KDE Plasma 6
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "arto";
  services.ddccontrol.enable = true;
  # services.rustdesk-server.enable = true;
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;

    extraConfig.pipewire."99-best-quality" = {
      context.properties = {
        default.clock.allowed-rates = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
        resample.quality = 10;
        default.clock.quantum = 1024;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 2048;
      };
    };
  };

  # System Services
  services.openssh.enable = true;
  zramSwap.enable = true;
  # User Management (delegates to Home Manager)
  users.users.arto = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "i2c"
    ];
    shell = pkgs.fish;
  };
  system.activationScripts.fixDownloadsOwnership = {
    text = ''
      chown arto:users /home/arto/Downloads
    '';
    deps = [ "users" ];
  };
  # System-wide Packages and Programs
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    git
    btrfs-progs
    kdePackages.plasma-browser-integration
    kdePackages.discover
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.kjournald
    kdePackages.sddm-kcm
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    hardinfo2
    haruna
    wayland-utils
    wl-clipboard-rs
    lact
    catppuccin-kde
    unzip
    nixfmt
    nixd
    typst
    tinymist
    typstyle
    zotero
    tidal-hifi
    inputs.fenix.packages.${pkgs.system}.complete.toolchain
    bpftools
    llvm
    clang
    linuxPackages.kernel.dev
    linuxPackages.bpftrace
    onlyoffice-bin
    rustdesk-flutter
    vesktop
    prusa-slicer
    libldac
    pavucontrol
    pwvucontrol
  ];
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];
  programs.firefox.enable = true;
  programs.bcc.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "frappe";
  catppuccin.accent = "green";
  system.stateVersion = "25.05";
}
