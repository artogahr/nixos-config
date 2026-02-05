{ config, lib, desktopShell ? "dms", ... }:
{
  # Kanshi - automatic output profiles for Wayland (e.g. niri)
  #
  # This is enabled only for the DMS/niri shell. It runs per-user and
  # automatically applies profiles based on which monitors are connected.
  #
  # Profiles below are safe placeholders; you'll want to adjust "criteria"
  # (output names) and add/remove profiles once you're at each machine.
  #
  # To discover connector names and modes under niri, run inside a niri session:
  #
  #   niri msg outputs
  #
  # Then replace the example criteria ("eDP-1", "DP-5", "HDMI-A-1", …) with the
  # actual names that niri reports for your laptop panel and external screens.
  # NOTE: Your Home Manager version does not expose `programs.kanshi` yet,
  # so this file is currently just a commented template. Once you update to
  # a Home Manager release that has kanshi support, you can uncomment the
  # block below and it should work as-is (after adjusting criteria/positions).
  #
  # programs.kanshi = {
  #   # Disabled by default so you can safely switch to this config now.
  #   # When you're ready and have verified connector names with:
  #   #
  #   #   niri msg outputs
  #   #
  #   # flip this to `desktopShell == "dms"` to turn kanshi on:
  #   #
  #   #   enable = desktopShell == "dms";
  #   #
  #   # Until then, kanshi is completely inert.
  #   enable = false;
  #
  #   # Per-host kanshi profiles. Home Manager sees the system hostName, so we
  #   # can branch here and keep configs separate for fukurowl-pc vs thinkpad.
  #   profiles =
  #     if (config ? networking && config.networking ? hostName && config.networking.hostName == "fukurowl-pc") then {
  #       # Example for the desktop ("fukurowl-pc").
  #       #
  #       # Replace "DP-5" and "HDMI-A-1" with the real connector names from:
  #       #   niri msg outputs
  #       #
  #       # This profile assumes:
  #       #   - You have a single primary monitor (e.g. DP-5) front and center.
  #       #   - Optionally, a second side monitor (e.g. HDMI-A-1) to the right.
  #       #
  #       # kanshi will apply whichever profile matches the *exact* set of
  #       # currently-connected outputs.
  #       single-main.outputs = [
  #         {
  #           # Single-monitor setup: only the main display is connected.
  #           # criteria = "DP-5"; # ← uncomment & adjust when known
  #           criteria = "DP-5";
  #           status = "enable";
  #           primary = true;
  #           position = "0,0";
  #         }
  #       ];
  #
  #       dual-main-right.outputs = [
  #         {
  #           # Main monitor in front.
  #           # criteria = "DP-5"; # ← main display
  #           criteria = "DP-5";
  #           status = "enable";
  #           primary = true;
  #           position = "0,0";
  #         }
  #         {
  #           # Secondary monitor placed to the right of the main one.
  #           # Set X to your main monitor's logical width (e.g. 1920 for 1080p).
  #           # criteria = "HDMI-A-1"; # ← side display
  #           criteria = "HDMI-A-1";
  #           status = "enable";
  #           position = "1920,0";
  #         }
  #       ];
  #     } else if (config ? networking && config.networking ? hostName && config.networking.hostName == "fukurowl-thinkpad") then {
  #       # Example profiles for the laptop ("fukurowl-thinkpad").
  #       #
  #       # Common setups:
  #       #   - undocked: laptop panel only (eDP-1)
  #       #   - docked: external monitor as primary, laptop panel disabled
  #       #
  #       # Adjust "criteria" and "position" once you know your exact connector
  #       # names and resolutions.
  #
  #       undocked.outputs = [
  #         {
  #           # Laptop-only profile (no external screens).
  #           # Built-in panel is almost always called "eDP-1".
  #           criteria = "eDP-1";
  #           status = "enable";
  #           primary = true;
  #           position = "0,0";
  #         }
  #       ];
  #
  #       docked-external-primary.outputs = [
  #         {
  #           # External monitor as primary when docked.
  #           # Replace "HDMI-A-1" with your actual external connector name.
  #           criteria = "HDMI-A-1";
  #           status = "enable";
  #           primary = true;
  #           position = "0,0";
  #         }
  #         {
  #           # Laptop screen disabled when docked. If you prefer to keep it on
  #           # but off to the side, change status="enable" and give it a
  #           # position like "1920,0" instead.
  #           criteria = "eDP-1";
  #           status = "disable";
  #         }
  #       ];
  #     } else
  #       # Default: no kanshi profiles on unknown hosts. Safe no-op.
  #       { };
  # };
}

