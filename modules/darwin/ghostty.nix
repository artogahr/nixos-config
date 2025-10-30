{ config, ... }:

{
  # Ghostty configuration (installed via brew for now)
  # Once ghostty is in nixpkgs, we can use: programs.ghostty.enable = true
  
  xdg.configFile."ghostty/config".text = ''
    # Theme
    theme = catppuccin-${config.catppuccin.flavor}
    
    # Font
    font-family = "Cascadia Code"
    font-size = 13
    
    # Window
    window-decoration = false
    window-padding-x = 10
    window-padding-y = 10
    
    # Shell integration
    shell-integration = true
    shell-integration-features = cursor,sudo,title
    
    # Misc
    confirm-close-surface = false
    copy-on-select = false
  '';
}
