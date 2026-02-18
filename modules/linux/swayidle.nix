{
  pkgs,
  ...
}:
let
  lockCommand = "${pkgs.systemd}/bin/systemctl --user start dms-lock.service";
in
{
  systemd.user.services.dms-lock = {
    Unit.Description = "DMS lock screen";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.dms-shell}/bin/dms ipc call lock lock";
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = lockCommand;
      }
      {
        timeout = 420;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 900;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = {
      before-sleep = lockCommand;
      lock = lockCommand;
    };
  };
}
