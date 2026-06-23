{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "apify-cli"
      "omlx"
      "omp"
    ];
    casks = [
      "monitorcontrol"
      "ghostty"
      "middledrag"
      "claude"
      "tidal"
      "steam"
      "lastpass"
      "bitwarden"
      "stremio"
      "onlyoffice"
      "logi-options+"
      "orion"
      "prusaslicer"
      "balenaetcher"
      "macfuse"
      "karabiner-elements"
      "domzilla-caffeine"
      "ollama-app"
      "discord"
      "zen"
      "rawtherapee"
      "codexbar"
      "vorssaint"
    ];
  };
}
