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
    power-profiles-daemon.enable = true;
  };

  # Log which device woke the system (run: suspend → when it wakes, check /var/log/last-wakeup-sources.txt).
  # The line with non-zero "active_since" (or high event_count) is the culprit; first column is the name for udev.
  environment.etc."systemd/system-sleep/capture-wakeup-sources" = {
    source = pkgs.writeShellScript "capture-wakeup-sources" ''
      case "$1" in
        post)
          if [ "$2" = "suspend" ] || [ "$2" = "hibernate" ]; then
            mkdir -p /var/log
            mount -t debugfs none /sys/kernel/debug 2>/dev/null || true
            cat /sys/kernel/debug/wakeup_sources 2>/dev/null > /var/log/last-wakeup-sources.txt || true
            echo "--- captured at $(date) ---" >> /var/log/last-wakeup-sources.txt
          fi
          ;;
      esac
    '';
    mode = "0755";
  };

  # Disable wake from the specific PCI device that was triggering immediate wake (0000:00:01.1)
  services.udev.extraRules = ''
    SUBSYSTEM=="pci", KERNEL=="0000:00:01.1", ATTR{power/wakeup}="disabled"
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
