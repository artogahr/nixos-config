# /nixos-config/modules/wezterm.nix
{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      background-opacity = 0.7;
      background-blur = true;
      bell-features = "system";
    };
  };
}
