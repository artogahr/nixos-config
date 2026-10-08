# Shared CLI packages for all hosts (NixOS + nix-darwin). System module, auto-imported by flake.nix.
# GUI apps for the graphical hosts live in ./desktop.
{ pkgs, ... }:
{
  # CLI tools, installed per-user. sharedModules applies regardless of the differing usernames.
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        programs = {
          gh.enable = true;
          htop.enable = true;
          ripgrep.enable = true;
          fd.enable = true;
          jq.enable = true;
          yazi = {
            enable = true;
            enableFishIntegration = false;
            shellWrapperName = "y";
          };
          delta = {
            enable = true;
            enableGitIntegration = true;
          };
        };

        home.packages = with pkgs; [
          tree
          wget
          unzip
          ncdu
          doggo
          unrar
          ffmpeg
          docker-compose
          wireguard-tools
          nixfmt
          sops
          age
          nixd
          typst
          tinymist
          typstyle
        ];
      }
    )
  ];
}
