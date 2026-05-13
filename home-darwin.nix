# Entry point for home-manager on nix-darwin hosts.
# Auto-imports every .nix file in modules/common and modules/darwin/home.
{ pkgs, lib, ... }:

let
  importModules =
    dir:
    map (name: dir + "/${name}") (
      builtins.attrNames (
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (builtins.readDir dir)
      )
    );
in
{
  imports =
    (importModules ./modules/common)
    ++ (importModules ./modules/darwin/home);
}
