{
  config,
  osConfig,
  lib,
  desktopShell ? "noctalia",
  ...
}:
{
  services.kanshi = {
    enable = desktopShell == "noctalia";
    # systemdTarget = "hyprland-session.target";

    # Per-host kanshi profiles. Home Manager sees the system hostName, so we
    # can branch here and keep configs separate for fukurowl-pc vs thinkpad.
    settings =
      if (osConfig.networking.hostName == "fukurowl-pc") then
        [
          {
            profile = {
              name = "Default_Philips_Ultrawide";
              outputs = [
                {
                  criteria = "*34M2C3500L*";
                  scale = 1.0;
                  # mode = "3440x1440@165.001007";
                  status = "enable";
                  adaptiveSync = false;
                }
              ];
            };
          }
        ]
      else if (osConfig.networking.hostName == "fukurowl-thinkpad") then
        [
          {
            profile = {
              name = "undocked";
              outputs = [
                {
                  criteria = "eDP-1";
                  status = "enable";
                }
              ];
            };
          }
          {
            profile = {
              name = "docked";
              outputs = [
                {
                  criteria = "*";
                  status = "enable";
                  adaptiveSync = false;
                }
                {
                  criteria = "eDP-1";
                  status = "disable";
                }
              ];
            };
          }
          # Example profiles for the laptop ("fukurowl-thinkpad").
          #
          # Common setups:
          #   - undocked: laptop panel only (eDP-1)
          #   - docked: external monitor as primary, laptop panel disabled
          #
          # Adjust "criteria" and "position" once you know your exact connector
          # names and resolutions.

          # undocked.outputs = [
          #   {
          #     # Laptop-only profile (no external screens).
          #     # Built-in panel is almost always called "eDP-1".
          #     criteria = "eDP-1";
          #     status = "enable";
          #     primary = true;
          #     position = "0,0";
          #   }
          # ];
          #
          # docked-external-primary.outputs = [
          #   {
          #     # External monitor as primary when docked.
          #     # Replace "HDMI-A-1" with your actual external connector name.
          #     criteria = "HDMI-A-1";
          #     status = "enable";
          #     primary = true;
          #     position = "0,0";
          #   }
          #   {
          #     # Laptop screen disabled when docked. If you prefer to keep it on
          #     # but off to the side, change status="enable" and give it a
          #     # position like "1920,0" instead.
          #     criteria = "eDP-1";
          #     status = "disable";
          #   }
          # ];
        ]
      else
        # Default: no kanshi profiles on unknown hosts. Safe no-op.
        [ ];
  };
}
