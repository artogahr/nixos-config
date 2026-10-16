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
      "meetingbar"
      "notion" # nixpkgs' notion-app lags upstream by months
      "telegram" # the native macOS client; nixpkgs only has telegram-desktop
      "vlc"
    ];
  };
}
