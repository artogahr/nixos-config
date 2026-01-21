# Desktop-specific configuration (AMD Ryzen + Radeon)
{ config, pkgs, ... }:
{
  networking.hostName = "fukurowl-pc";

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [
      "i2c-dev"
      "amdgpu"
      "kvm-amd"
    ];
  };

  hardware = {
    i2c.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.clr
        rocmPackages.rocminfo
        rocmPackages.rocm-runtime
      ];
    };

    amdgpu = {
      opencl.enable = true;
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
      initrd.enable = true;
    };

    cpu.amd.updateMicrocode = true;
  };

  services = {
    ddccontrol.enable = true;
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
    power-profiles-daemon.enable = false;
  };

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  # LACT for AMD GPU control
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };

  users.users.arto.extraGroups = [ "i2c" ];

  programs = {
    bcc.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    ROC_ENABLE_PRE_VEGA = "1";
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";
  };

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    lact
    radeontop
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    openrgb-with-all-plugins
    prusa-slicer
    quickemu
    gnome-boxes
  ];
}
