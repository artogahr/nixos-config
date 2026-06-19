# Entry point for home-manager on nix-darwin hosts.
# Auto-imports every .nix file in modules/common and modules/darwin/home.
{ pkgs, lib, importDir, ... }:
{
  imports =
    importDir ./modules/common
    ++ importDir ./modules/darwin/home;
}
