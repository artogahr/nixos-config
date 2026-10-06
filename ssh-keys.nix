# Public SSH keys by device. Hosts choose from this set (modules/linux/nixos/base.nix,
# modules/darwin/nix-darwin/openssh.nix, hosts/fukurowl-devbox, modules/common/git-work.nix).
{
  # Origin not recorded; trusted on the NixOS hosts since before this file existed.
  legacy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKMu8p91vFMlCogmKOpImn/0gDpgs3jkKQk9h6Iw3Yj";
  # MacBook, held by the 1Password SSH agent. Also its git signing key.
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvruz8r3DI5LLUfK//haryWKgq8mE35nR7FZamfO/YR";
  # Galaxy S24, herdroid app.
  phone = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACH2OlGYvVK5PmhJa/C55c0BqpOLNbVVZ+veZqlo1Qi herdroid@SM-S921B";
}
