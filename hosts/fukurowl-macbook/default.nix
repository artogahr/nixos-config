# Host-specific config for the MacBook.
# Keep this slim — anything that should apply to every macOS host belongs in
# modules/darwin/nix-darwin instead.
{ pkgs, ... }:
{
  # macOS exposes three "hostname"s and nix-darwin lets you set all of them:
  #   hostName       → `scutil --get HostName`     (what `hostname` reports, shell prompts use)
  #   localHostName  → `scutil --get LocalHostName` (the Bonjour/.local name on the network)
  #   computerName   → `scutil --get ComputerName`  (friendly name in Finder / Sharing prefs)
  networking.hostName = "fukurowl-macbook";
  networking.localHostName = "fukurowl-macbook";
  networking.computerName = "fukurowl-macbook";

  # Per-host packages installed system-wide (very minimal for now).
  environment.systemPackages = with pkgs; [
    git
  ];
}
