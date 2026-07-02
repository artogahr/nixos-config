{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    raycast
    maccy
    stats
    mos
    alt-tab-macos
    localsend
    utm
    whatsapp-for-mac
  ];
}
