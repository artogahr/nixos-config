# Desktop/shell selector. Override per-host in hosts/<name>/default.nix with: desktop.shell = "plasma";
{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  shell = config.desktop.shell;
in
{
  options.desktop.shell = lib.mkOption {
    type = lib.types.enum [ "dms" "plasma" ];
    default = "dms";
    description = ''
      Which desktop shell to use. Drives display manager, compositor, and related modules.
      Add more enum values in this file when you try other shells (e.g. hyprland).
    '';
  };

  config = {
    home-manager.extraSpecialArgs = { inherit inputs; desktopShell = shell; };

    services = {
      desktopManager.plasma6.enable = shell == "plasma";

      displayManager.sddm = mkIf (shell == "plasma") {
        enable = true;
        wayland.enable = true;
      };

      displayManager.dms-greeter = mkIf (shell == "dms") {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/arto";
      };
    };

    programs = {
      dms-shell.enable = shell == "dms";
      niri.enable = shell == "dms";
    };
  };
}
