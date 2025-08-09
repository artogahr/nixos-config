{ ... }:

{
  xdg.configFile = {
    # Symlink Neovim configuration
    "nvim".source = ../dotfiles/nvim;
    
    # Add other dotfile symlinks here as needed
    # Example:
    # "alacritty".source = ../dotfiles/alacritty;
    # "tmux".source = ../dotfiles/tmux;
  };
}
