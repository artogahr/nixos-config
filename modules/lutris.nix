{ pkgs, ... }:

{
  programs.lutris = {
    enable = true;
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
