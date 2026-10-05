# Shared CLI packages for all hosts (NixOS + nix-darwin). System module, auto-imported by flake.nix.
# GUI apps for the graphical hosts live in ./desktop.
{ pkgs, ... }:
{
  # CLI tools, installed per-user. sharedModules applies regardless of the differing usernames.
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          tree
          gh
          htop
          ripgrep
          fd
          jq
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
