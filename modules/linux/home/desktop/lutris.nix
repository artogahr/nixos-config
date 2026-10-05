{ pkgs, ... }:

{
  programs.lutris = {
    enable = false;
    extraPackages = with pkgs; [
      mangohud
      wine-wayland
      winetricks
      gamescope
      gamemode
      umu-launcher
    ];
  };
}
