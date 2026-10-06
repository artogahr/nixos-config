# Work repos under ~/workplace/apify commit as arto@apify.com, signed with this host's own SSH
# signing key. Create it once per host with
#   ssh-keygen -t ed25519 -N "" -C "git signing $(hostname)" -f ~/.ssh/id_ed25519_signing
# and register the .pub on GitHub as a signing key. (The Mac signs everything through 1Password.)
{ config, ... }:
let
  signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519_signing.pub";
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
