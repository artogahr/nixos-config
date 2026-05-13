# Ghostty config on macOS.
# The Ghostty app itself is installed via Homebrew cask (see modules/darwin/nix-darwin/homebrew.nix),
# because the nixpkgs build of Ghostty doesn't reliably work on darwin. We just deploy the
# config file declaratively — Ghostty reads it from ~/.config/ghostty/config.
{ ... }:
{
  home.file.".config/ghostty/config".text = ''
    background-opacity = 0.92
    background-blur = true
    bell-features = system
    font-family = Cascadia Code
    font-size = 14
    theme = catppuccin-mocha
  '';
}
