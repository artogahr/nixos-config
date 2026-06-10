{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    raycast
    maccy
    stats
    betterdisplay
    mos
    alt-tab-macos
    localsend
    utm
    whatsapp-for-mac
  ];
}
