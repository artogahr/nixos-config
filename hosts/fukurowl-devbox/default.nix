# Always-on headless dev agent box: NixOS VM on proxmox2, reached over Tailscale.
{ config, lib, ... }:
{
  networking.hostName = "fukurowl-devbox";

  services.qemuGuest.enable = true;

  # 1Password CLI (`op`). No desktop app here, so no app integration or 1Password SSH agent;
  # `op` authenticates with a service account token or `op signin`.
  programs._1password.enable = true;

  # agent-sandbox.nix's allowNix refuses to run for a trusted Nix user, so only root is trusted here.
  nix.settings.trusted-users = lib.mkForce [ "root" ];

  networking.firewall.enable = lib.mkForce true;
  services.tailscale.openFirewall = true;

  services.openssh.settings = {
    PasswordAuthentication = lib.mkForce false;
    KbdInteractiveAuthentication = false;
    # Root logs in with the same key as arto, to bootstrap `passwd arto` and `tailscale up`
    # after nixos-anywhere, and as a recovery path.
    PermitRootLogin = "prohibit-password";
  };
  users.users.root.openssh.authorizedKeys.keys = config.users.users.arto.openssh.authorizedKeys.keys;

  system.stateVersion = lib.mkForce "26.11";
}
