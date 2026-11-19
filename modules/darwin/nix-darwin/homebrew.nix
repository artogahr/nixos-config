{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };
    # Required for casks from third-party taps: brew bundle refuses to load
    # darrylmorley/whatcable's cask unless the tap is declared here.
    taps = [
      "darrylmorley/whatcable"
      "lzt1008/powerflow"
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
      "meetingbar"
      "notion"
      "telegram"
      "vlc"
      "tailscale-app"
      "powerflow"
    ];
    masApps = {
      WireGuard = 1451685025;
    };
  };
}
