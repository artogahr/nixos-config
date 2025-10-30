{ ... }:

{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      pane_frames = false;
      # Enable OSC passthrough for plugins like bg.nvim
      copy_command = "pbcopy";  # macOS clipboard
      scrollback_editor = "nvim";
    };
  };
  
  # Ensure proper TERM for color support
  programs.fish.shellInit = ''
    if set -q ZELLIJ
      set -gx TERM xterm-256color
    end
  '';
}
