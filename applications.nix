{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    git
    unzip
    btrfs-progs
    nixfmt
    nixd
    bpftools
    llvm
    clang
    linuxPackages.kernel.dev
    linuxPackages.bpftrace
    typst
    tinymist
    typstyle
    zotero
    onlyoffice-bin
    haruna
    # tidal-hifi
    pavucontrol
    pwvucontrol
    vesktop
    rustdesk-flutter
    hardinfo2
    lact
    wayland-utils
    wl-clipboard-rs
    kdePackages.plasma-browser-integration
    kdePackages.discover
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.kjournald
    kdePackages.sddm-kcm
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    catppuccin-kde
    prusa-slicer
    inputs.fenix.packages.${pkgs.system}.complete.toolchain
    inputs.tidaLuna.packages.${pkgs.system}.default
    oneko
    wayneko
    lm_sensors
    dmidecode
    gemini-cli
    # stremio
    google-chrome
    ffmpeg
    # jellyfin-media-player
    easyeffects
    code-cursor
    todoist
    cursor-cli
  ];
}
