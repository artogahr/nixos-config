{
  pkgs,
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
    upower.enable = true;

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
        CPU_BOOST_ON_BAT = 0;

        PLATFORM_PROFILE_ON_BAT = "low-power";

        PCIE_ASPM_ON_BAT = "powersupersave";
      };
    };
  };

  # Don't offer fingerprint in the greeter — it ends up prompting for both
  # password and fingerprint sequentially. Fingerprint still works for sudo/unlock.
  security.pam.services.greetd.fprintAuth = false;

  # Lower quantum than desktop default (256 vs 1024) — ~5ms latency, fine for laptop use
  services.pipewire.extraConfig.pipewire."99-thinkpad-settings" = {
    context.properties."default.clock.quantum" = 256;
  };

  networking.networkmanager.wifi.powersave = false;

  environment.systemPackages = with pkgs; [
    powertop
    intel-gpu-tools
    tlp
    tlp-pd
    acpi
    nvme-cli
    lm_sensors
  ];
}
