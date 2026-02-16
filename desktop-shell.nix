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
    type = lib.types.enum [ "noctalia" "plasma" ];
    default = "noctalia";
    description = ''
      Which desktop shell to use. Drives display manager, compositor, and related modules.
    '';
  };

  config = {
    home-manager.extraSpecialArgs = { inherit inputs; desktopShell = shell; };

    services = {
      desktopManager.plasma6.enable = shell == "plasma";

      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    programs.niri.enable = shell == "noctalia";
  };
}
