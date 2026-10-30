# Command-line tools for every NixOS host, desktop or headless.
{ pkgs, inputs, ... }:
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
