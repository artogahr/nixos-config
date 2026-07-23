# Shared packages for all hosts (NixOS + nix-darwin). System module, auto-imported by flake.nix.
{ pkgs, ... }:
{
  # GUI/system apps go here, not in home.packages, so darwin indexes them in Spotlight.
  environment.systemPackages = with pkgs; [
    signal-desktop
    spotify
  ];

  # CLI tools, installed per-user. sharedModules applies regardless of the differing usernames.
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          tree
          gh
          github-copilot-cli
          htop
          ripgrep
          fd
          delta
          wget
          unzip
          ncdu
          yazi
          doggo
          unrar
          ffmpeg
          docker-compose
          wireguard-tools
          cursor-cli
          antigravity-cli
          nixfmt
          nixd
          typst
          tinymist
          typstyle
        ];
      }
    )
  ];
}
