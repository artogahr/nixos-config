# Desktop-specific configuration (AMD Ryzen + Radeon)
{ config, pkgs, ... }:
{
  networking.hostName = "fukurowl-pc";

  fileSystems."/mnt/skhynix" = {
    device = "/dev/disk/by-uuid/976767c1-fb41-49d0-9417-eeef4a4b8f2d";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [
      "amdgpu"
      "kvm-amd"
      "ntsync"
    ];
  };

  hardware = {
    i2c.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      # rocmPackages.clr(.icd) come from hardware.amdgpu.opencl.enable below; only the
      # runtime lib needs adding explicitly here.
      extraPackages = with pkgs; [ rocmPackages.rocm-runtime ];
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
  '';

  # Denon HDMI 5.1 channel order quirk on this desktop host.
  environment.etc."wireplumber/wireplumber.conf.d/90-hdmi-5.1-channel-order.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            node.name = "~alsa_output.*hdmi-surround-extra3"
          }
        ]
        actions = {
          update-props = {
            audio.position = "FL,FR,SL,SR,FC,LFE"
          }
        }
      }
    ]
  '';

  # LACT for AMD GPU control
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };

  users.users.arto.extraGroups = [ "i2c" ];

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";
  };

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    lact
    radeontop
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    prusa-slicer
    quickemu
    gnome-boxes
  ];
}
