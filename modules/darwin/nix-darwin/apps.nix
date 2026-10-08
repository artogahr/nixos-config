{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    raycast
    alt-tab-macos
    localsend
    utm
    whatsapp-for-mac
  ];
}
