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

  # Static 10.0.0.23 (homelab convention: 10.0.0.<VMID - 100>, VMID 123), matched by the
  # Proxmox NIC's MAC so the interface name doesn't matter. Update the MAC if the VM is recreated.
  networking.networkmanager.enable = lib.mkForce false;
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.nameservers = [ "10.0.0.3" ]; # AdGuard
  systemd.network.networks."10-lan" = {
    matchConfig.MACAddress = "bc:24:11:b1:39:11";
    address = [ "10.0.0.23/24" ];
    gateway = [ "10.0.0.1" ];
  };

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

  # Start arto's user services (sops-nix secrets, agents) at boot, not only after a login.
  users.users.arto.linger = true;

  system.stateVersion = lib.mkForce "26.11";
}
