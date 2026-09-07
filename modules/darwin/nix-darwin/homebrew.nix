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
      # "middledrag"
      "claude"
      "chatgpt" # also the Codex desktop app; the codex-app cask is deprecated in its favour
      "tidal"
      "steam"
      # "lastpass"
      # "bitwarden"
      "stremio"
      "onlyoffice"
      # "logi-options+"
      # "orion"
      "prusaslicer"
      # "balenaetcher"
      # "macfuse"
      "karabiner-elements"
      # "domzilla-caffeine"
      "discord"
      "zed"
      "zen"
      # "rawtherapee"
      "codexbar"
      "vorssaint"
      "whatcable"
      "1password-cli"
      "meetingbar"
      "vlc"
    ];
  };
}
