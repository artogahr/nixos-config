# udiskie - automount removable drives (USB etc.) with notifications
# Works with udisks2 (system service). User must be in "storage" group.
# Mounts appear under /run/media/<user>/<label> and are writable without sudo.
{
  config,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.udiskie ];

  systemd.user.services.udiskie = {
    Unit = {
      Description = "udiskie removable disk automounter";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.udiskie}/bin/udiskie --automount --notify --no-tray";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
