# Entry point for home-manager on NixOS hosts.
# Auto-imports every .nix file in modules/common and modules/linux/home.
{ pkgs, lib, importDir, ... }:
{
  imports =
    importDir ./modules/common
    ++ importDir ./modules/linux/home;
}
