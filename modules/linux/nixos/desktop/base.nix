# Desktop session, audio, gaming and hardware integrations for the graphical NixOS hosts.
{ pkgs, ... }:
{
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  networking.extraHosts = "0.0.0.0 apresolve.spotify.com";

  hardware = {
    steam-hardware.enable = true;

    bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };
  };

  security.rtkit.enable = true;

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts.monospace = [ "Cascadia Code" ];
    };
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;

      extraConfig.pipewire."99-sensible-settings" = {
        context.properties = {
          resample.quality = 10;
          default.clock.quantum = 1024;
        };
      };
    };

    udisks2.enable = true;
    gvfs.enable = true;
    xserver.enable = true;

    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    flatpak.enable = true;
    fwupd.enable = true;

    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true; # network printer discovery
    };

    syncthing = {
      enable = true;
      user = "arto";
      dataDir = "/home/arto";
    };

    geoclue2 = {
      enable = true;
      enableStatic = true;
      staticLatitude = 50.000;
      staticLongitude = 14.500;
      staticAltitude = 200;
      staticAccuracy = 10000;
    };

    logind.settings.Login = {
      HandlePowerKey = "lock";
      HandlePowerKeyLongPress = "suspend";
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs = {
    firefox.enable = true;
    dconf.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    gamemode.enable = true;
    kdeconnect.enable = true;
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  catppuccin.cursors.enable = true;
}
