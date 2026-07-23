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
      "oh-my-posh"
      "kimi-code"
    ];
    taps = [
      "homebrew/cask"
      "darrylmorley/whatcable"
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
      # "macfuse"
      "karabiner-elements"
      "domzilla-caffeine"
      "ollama-app"
      "discord"
      "zed"
      "zen"
      "rawtherapee"
      "codexbar"
      "vorssaint"
      "whatcable"
    ];
  };
}
