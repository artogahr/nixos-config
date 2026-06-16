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
      "nikitabobko/tap"
      {
        name = "jundot/omlx";
        clone_target = "https://github.com/jundot/omlx";
      }
    ];
    brews = [
      "apify-cli"
      "omlx"
    ];
    casks = [
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
    ];
  };
}
