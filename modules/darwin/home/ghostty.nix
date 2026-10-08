# Ghostty config on macOS. The app comes from the Homebrew cask (modules/darwin/nix-darwin/homebrew.nix)
# because the nixpkgs build doesn't reliably work on darwin, so home-manager only writes the config.
{ ... }:
{
  # The catppuccin module pins one flavor; the theme below follows the system appearance.
  catppuccin.ghostty.enable = false;

  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      background-opacity = 0.90;
      background-blur = true;
      bell-features = "system";
      font-family = "Cascadia Code";
      font-size = 14;
      theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
      shell-integration = "detect";
      window-padding-x = 0;
      window-padding-y = 0;
      window-padding-color = "extend";
    };
  };
}
