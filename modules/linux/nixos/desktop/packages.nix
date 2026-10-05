# Desktop applications for the graphical NixOS hosts
{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    zotero
    onlyoffice-desktopeditors
    haruna
    pavucontrol
    pwvucontrol
    vesktop
    hardinfo2
    wayland-utils
    kdePackages.plasma-browser-integration
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.kjournald
    kdePackages.sddm-kcm
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    catppuccin-kde
    google-chrome
    code-cursor
    todoist
    clinfo
    qbittorrent
    discord
    dnsmasq
    phodav
    obs-studio
    galaxy-buds-client
    xev
    spotify-tray
  ];
}
