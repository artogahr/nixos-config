# feh is X11-only. On Wayland (niri) it needs xwayland-satellite in PATH so niri sets DISPLAY.
# configuration.nix adds environment.systemPackages = [ pkgs.xwayland-satellite ] and programs.xwayland.enable.
{ ... }:

{
  programs.feh.enable = true;
}
