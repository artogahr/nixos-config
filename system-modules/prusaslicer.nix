{ pkgs, ... }:

{
  environment.etc."xdg/PrusaSlicerURLProtocol.desktop".source =
    pkgs.writeText "prusaslicer-url-protocol.desktop" ''
      [Desktop Entry]
      Name=PrusaSlicer URL Protocol
      Exec=${pkgs.prusa-slicer}/bin/prusa-slicer --single-instance %u
      Terminal=false
      Type=Application
      MimeType=x-scheme-handler/prusaslicer;
      StartupNotify=false
      NoDisplay=true
    '';
}
