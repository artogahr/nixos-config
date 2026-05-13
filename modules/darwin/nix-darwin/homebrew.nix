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
    taps = [ ];
    brews = [ ];
    casks = [
      "ghostty"
      "middledrag"
      "claude"
      "claude-code"
    ];
  };
}
