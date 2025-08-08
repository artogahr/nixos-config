# /nixos-config/configuration.nix
{ config, pkgs, inputs, ... }:

{
  # Core NixOS Settings
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
    gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 30d"; };
  };

  # Bootloader and Kernel
  boot.loader.grub = { enable = true; device = "nodev"; efiSupport = true; };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = ["i2c-dev"];
  services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  # Networking
  networking.hostName = "fukurowl-pc";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true;
  hardware.amdgpu.overdrive.enable = true;

  # Time, Locale, and Fonts
  time.timeZone = "Europe/Prague";
  i18n.defaultLocale = "en_US.UTF-8";
  fonts.packages = with pkgs; [ noto-fonts noto-fonts-cjk-sans noto-fonts-emoji ];

  # Desktop Environment: KDE Plasma 6
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = { enable = true; wayland.enable = true; };
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "arto";
  services.ddccontrol.enable = true;
  services.lact.enable = true;

  # Sound
  services.pipewire = { enable = true; pulse.enable = true; alsa.enable = true; alsa.support32Bit = true; };

  # System Services
  services.openssh.enable = true;
  zramSwap.enable = true;

  # User Management (delegates to Home Manager)
  users.users.arto = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "i2c" ];
    shell = pkgs.fish;
  };

  system.activationScripts.fixDownloadsOwnership = {
    text = ''
      chown arto:users /home/arto/Downloads
    '';
    deps = [ "users" ];
  };
  
  # Home Manager Integration
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    users.arto = import ./home.nix;
  };

  # System-wide Packages and Programs
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ wget git btrfs-progs kdePackages.plasma-browser-integration lact ];
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.firefox.enable = true;

  system.stateVersion = "25.05";
}
