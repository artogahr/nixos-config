{ pkgs, lib, ... }:

let
  importModules = dir: map (name: dir + "/${name}") (
    builtins.attrNames (
      lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
        builtins.readDir dir
      )
    )
  );
in
{
  imports = importModules ./modules/common;

  home.username = "artogahr";
  home.homeDirectory = "/Users/artogahr";
  home.stateVersion = "25.05";
  
  # Basic packages that work on macOS
  home.packages = with pkgs; [
    tree
    ripgrep
    fd
    cascadia-code
  ];

  programs.home-manager.enable = true;
  
  # Catppuccin theme settings
  catppuccin.enable = true;
  catppuccin.flavor = "latte";
}