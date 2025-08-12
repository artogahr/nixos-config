{ pkgs, lib, ... }:

{
  imports = map (name: ./modules + "/${name}") 
    (builtins.attrNames (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) 
      (builtins.readDir ./modules)));

  home.stateVersion = "25.05";

  # User-level packages
  home.packages = with pkgs; [
    tree
    anydesk
    gh
    delta
    telegram-desktop
    htop
    ripgrep
    fd
  ];

  programs.home-manager.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  catppuccin.kvantum.enable = true;
  catppuccin.kvantum.apply = true;

  qt.style.name = "kvantum";
  qt.platformTheme.name = "kvantum";
}
