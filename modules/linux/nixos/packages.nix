# Command-line tools for every NixOS host, desktop or headless.
{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    btrfs-progs
    inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.complete.toolchain
    lm_sensors
    dmidecode
    sshfs
    usbutils
  ];
}
