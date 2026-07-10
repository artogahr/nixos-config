{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    raycast
    maccy
    mos
    alt-tab-macos
    localsend
    utm
    whatsapp-for-mac
  ];
}
