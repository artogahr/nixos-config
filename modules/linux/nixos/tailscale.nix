# Tailscale on every NixOS host. macOS uses the tailscale-app cask instead (see homebrew.nix).
{
  services.tailscale.enable = true;
}
