# ThinkPad T14s Gen 3 (Intel 1260P) configuration
{ config, pkgs, lib, ... }:
{
  networking.hostName = "fukurowl-thinkpad";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "intel_pstate=active"
    ];
    kernelModules = [ "kvm-intel" ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  # Power management for laptop
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = true;

    # Fingerprint reader (T14s Gen 3 has one)
    fprintd.enable = true;

    # Better touchpad support
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = true;
      };
    };
  };

  # Laptop power tweaks
  powerManagement.enable = true;

  # ThinkPad-specific packages
  environment.systemPackages = with pkgs; [
    powertop
    intel-gpu-tools
  ];
}
