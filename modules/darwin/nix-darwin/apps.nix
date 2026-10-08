{ pkgs, ... }:
{
  # Both copy into /Applications rather than Nix Apps: 1Password's browser integration and
  # op-ssh-sign (darwin/home/git.nix) expect /Applications/1Password.app and /usr/local/bin/op.
  programs._1password-gui.enable = true;
  programs._1password.enable = true;

  environment.systemPackages = with pkgs; [
    raycast
    alt-tab-macos
    localsend
    utm
    whatsapp-for-mac
    slack
    google-chrome
  ];
}
