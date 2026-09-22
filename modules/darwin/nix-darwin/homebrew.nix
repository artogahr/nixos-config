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
      "kimi-code"
    ];
    # Required for casks from third-party taps: brew bundle refuses to load
    # darrylmorley/whatcable's cask unless the tap is declared here.
    taps = [
      "homebrew/cask"
      "darrylmorley/whatcable"
    ];
    casks = [
      "monitorcontrol"
      "ghostty"
      "claude"
      "chatgpt" # also the Codex desktop app; the codex-app cask is deprecated in its favour
      "tidal"
      "steam"
      "stremio"
      "onlyoffice"
      "prusaslicer"
      "karabiner-elements"
      "discord"
      "zed"
      "zen"
      "codexbar"
      "vorssaint"
      "whatcable"
      "1password-cli"
      "meetingbar"
      "vlc"
      "coderabbit"
    ];
  };
}
