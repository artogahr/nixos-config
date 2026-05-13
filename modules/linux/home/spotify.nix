{ lib, ... }:

{
  services.spotifyd = {
    enable = true;
  };

  programs.spotify-player = {
    enable = true;
    settings = {
      theme = lib.mkForce "default";
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
