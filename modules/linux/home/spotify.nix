{ ... }:

{
  services.spotifyd = {
    enable = true;
  };

  # The catppuccin theme is imported from a derivation, which breaks evaluating this
  # host from a non-Linux machine. We use the built-in default theme anyway.
  catppuccin.spotify-player.enable = false;

  programs.spotify-player = {
    enable = true;
    settings = {
      theme = "default";
      # cover_img_scale = 2.0;
      border_type = "Rounded";
      layout = {
        playback_window_height = 12;
        playback_window_position = "Bottom";
        album_percent = 40;
        playlist_percent = 40;
      };
    };
  };
}
