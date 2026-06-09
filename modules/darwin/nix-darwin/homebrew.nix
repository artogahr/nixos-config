# Declarative Homebrew via nix-homebrew. Casks listed here are kept in sync on every
# darwin-rebuild switch. We use Homebrew for GUI apps that don't have a reliable native
# Nix build on macOS (e.g. Ghostty).
{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "FelixKratz/formulae"
      "nikitabobko/tap"
    ];
    brews = [
      "borders"
      "apify-cli"
    ];
    casks = [
      "ghostty"
      "middledrag"
      "claude"
      "claude-code"
      "betterdisplay"
      "maccy"
      "whatsapp"
      "tidal"
      "steam"
      "stats"
      "spotify"
      "whatsapp"
      "bitwarden"
      "lastpass"
      "stremio"
      "onlyoffice"
      "raycast"
      "karabiner-elements"
      "alt-tab"
      "logi-options+"
      "steam"
      "localsend"
      "discord"
      "utm"
      "signal"
      "orion"
      "balenaetcher"
      "macfuse"
      "mos"
      "prusaslicer"
      "domzilla-caffeine"
      "ollama"
    ];
  };
}
