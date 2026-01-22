# ThinkPad T14s Gen 3 (Intel 1260P) configuration
{ config, pkgs, lib, ... }:
{
  networking.hostName = "fukurowl-thinkpad";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "intel_pstate=active"
      "i915.enable_guc=3"  # Enable GuC and HuC for better media performance
    ];
    kernelModules = [ "kvm-intel" ];
    
    # WiFi: disable d0i3 deep sleep to prevent reconnection issues on ThinkPads
    extraModprobeConfig = ''
      options iwlwifi d0i3_disable=1
    '';
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
    fwupd.enable = true;  # Firmware updates for BIOS/drivers
    fstrim.enable = true;  # SSD TRIM for longevity

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

  # Keep WiFi awake to prevent slow reconnection after suspend (~20-30min battery cost)
  networking.networkmanager.wifi.powersave = false;

  # ThinkPad-specific packages
  environment.systemPackages = with pkgs; [
    powertop
    intel-gpu-tools
  ];
}
