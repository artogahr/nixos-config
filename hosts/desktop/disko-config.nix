# /nixos-config/disko-config.nix (Corrected)
{ lib, ... }:

let
  btrfs-opts = [
    "ssd"
    "noatime"
    "compress=zstd"
    "space_cache=v2"
    "discard=async"
  ];
in
{
  disko.devices = {
    disk = {
      main-nvme = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = btrfs-opts;
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = btrfs-opts;
                  };
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = btrfs-opts;
                  };
                  "/var/cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = btrfs-opts;
                  };
                  "/tmp" = {
                    mountpoint = "/tmp";
                    mountOptions = btrfs-opts;
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = btrfs-opts;
                  };

                  "/@downloads" = {
                    mountpoint = "/home/arto/Downloads";
                    mountOptions = btrfs-opts;
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
