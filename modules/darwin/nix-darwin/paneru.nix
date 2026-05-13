{ ... }:
{
  services.paneru = {
    enable = true;
    settings = {
      options = {
        focus_follows_mouse = true;
        mouse_follows_focus = false;
        animation_speed = 12.0;
      };
      # padding = {
      #   left = 18;
      #   right = 18;
      # };
      # decorations = {
      #   inactive.dim = {
      #     opacity = -0.15;
      #     opacity_night = -0.25;
      #   };
      #   active.border = {
      #     enabled = true;
      #     color = "#89b4fa";
      #     width = 2.0;
      #     radius = "auto";
      #   };
      # };
      # swipe.gesture = {
      #   fingers_count = 3;
      #   direction = "Natural";
      # };

      swipe = {
        continuous = false;
      };

      windows.all = {
        title = ".*";
        horizontal_padding = 4;
      };

      bindings = {
        window_focus_west = "cmd - h";
        window_focus_east = "cmd - l";
        window_resize = "alt - r";
        window_center = "alt - c";
        window_manage = "alt - t";
        quit = "ctrl + alt - q";
      };
    };
  };
}
