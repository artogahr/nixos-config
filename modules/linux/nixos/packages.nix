{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    btrfs-progs
    lm_sensors
    dmidecode
    sshfs
    usbutils
  ];
}
