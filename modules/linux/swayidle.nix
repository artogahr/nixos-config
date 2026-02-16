{
  pkgs,
  desktopShell ? "noctalia",
  ...
}:
{
  services.swayidle = {
    enable = desktopShell == "noctalia";
    timeouts = [
      {
        timeout = 300;
        command = "noctalia-shell ipc call lockScreen lock";
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
      before-sleep = "noctalia-shell ipc call lockScreen lock";
      lock = "noctalia-shell ipc call lockScreen lock";
    };
  };
}
