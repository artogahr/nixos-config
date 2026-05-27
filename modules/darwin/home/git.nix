{ lib, ... }:

{
  programs.git.settings = {
    user.email = lib.mkForce "arto@apify.com";
    user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvruz8r3DI5LLUfK//haryWKgq8mE35nR7FZamfO/YR";
    gpg.format = "ssh";
    "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    commit.gpgsign = true;
  };
}
