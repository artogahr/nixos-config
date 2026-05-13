# Ghostty terminal emulator configuration
# Linux-only (not available in nixpkgs for macOS)
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
