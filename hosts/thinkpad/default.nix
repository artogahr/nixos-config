{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "fukurowl-thinkpad";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "intel_pstate=active"
      "i915.enable_guc=3"
      "quiet"
      "splash"
    ];
    kernelModules = [ "kvm-intel" ];

    initrd.systemd.enable = true;

    extraModprobeConfig = ''
      options iwlwifi d0i3_disable=1
    '';
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  services = {
    thermald.enable = true;
    fwupd.enable = true;
    fstrim.enable = true;
    fprintd.enable = true;

    power-profiles-daemon.enable = false; # conflicts with TLP

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = true;
        middleEmulation = false;
      };
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        CPU_BOOST_ON_BAT = 0;

        PLATFORM_PROFILE_ON_BAT = "low-power";

        RUNTIME_PM_ON_BAT = "auto";

        PCIE_ASPM_ON_BAT = "powersupersave";

        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  powerManagement.enable = true;

  networking.networkmanager.wifi.powersave = false;

  environment.systemPackages = with pkgs; [
    powertop
    intel-gpu-tools
    tlp
    acpi
    nvme-cli
    lm_sensors
  ];
}
