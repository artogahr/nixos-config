# Work repos under ~/workplace/apify commit as arto@apify.com, signed. Everywhere else git uses
# the personal identity from git.nix.
# Signing key: on the Mac, the 1Password SSH agent's key (darwin/home/git.nix sets 1Password as the
# signer). On Linux, a per-host key; create it once with
#   ssh-keygen -t ed25519 -N "" -C "git signing $(hostname)" -f ~/.ssh/id_ed25519_signing
# and register the .pub on GitHub as a signing key.
{ config, pkgs, ... }:
let
  signingKey =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvruz8r3DI5LLUfK//haryWKgq8mE35nR7FZamfO/YR"
    else
      "${config.home.homeDirectory}/.ssh/id_ed25519_signing.pub";
in
{
  programs.git.includes = [
    {
      condition = "gitdir:~/workplace/apify/";
      contents = {
        user.email = "arto@apify.com";
        user.signingkey = signingKey;
        gpg.format = "ssh";
        commit.gpgsign = true;
        tag.gpgsign = true;
      };
    }
  ];
}
