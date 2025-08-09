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
    helix
    telegram-desktop
    htop
    ripgrep
    fd
  ];

  programs.home-manager.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "frappe";

  qt.style.name = "kvantum";
  qt.platformTheme.name = "kvantum";
}
