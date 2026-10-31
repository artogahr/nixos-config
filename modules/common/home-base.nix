# Cross-platform home-manager baseline.
# Shared by every host (NixOS and nix-darwin).
{ ... }:
{
  home.stateVersion = "25.05";

  manual.manpages.enable = false;

  programs.home-manager.enable = true;
  programs.uv.enable = true;

  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  catppuccin.flavor = "frappe";
  catppuccin.fish.enable = false;
  catppuccin.nvim.enable = false;

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.zellij = {
    enable = true;
    # Integration would auto-start zellij in every fish shell.
    enableFishIntegration = false;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
