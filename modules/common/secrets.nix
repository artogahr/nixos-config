{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/apify-token.enc;
    defaultSopsFormat = "binary";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets.apify-token = { };
  };
}
