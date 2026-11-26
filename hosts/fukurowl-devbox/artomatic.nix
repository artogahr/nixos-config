# Artomatic watches the Socials Instagram Actors for outages and starts agents
# The flake is in ~/workplace/apify/artomatic.
{ inputs, ... }:
{
  home-manager.users.arto =
    { config, ... }:
    {
      imports = [ inputs.artomatic.homeManagerModules.default ];
      services.artomatic = {
        enable = true;
        mode = "live";
        apifyTokenFile = config.sops.secrets.artomatic-apify-token.path;
        apifyProxyPasswordFile = config.sops.secrets.artomatic-apify-proxy-password.path;
        mezmoKeyFile = config.sops.secrets.mezmo-api-key.path;
        redashKeyFile = config.sops.secrets.redash-api-key.path;
        slackBotTokenFile = config.sops.secrets.artomatic-slack-bot-token.path;
        slackAppTokenFile = config.sops.secrets.artomatic-slack-app-token.path;
        apifyOrgTokenFile = "${config.home.homeDirectory}/.config/artomatic/org-token";
        zenhubTokenFile = "${config.home.homeDirectory}/.config/artomatic/zenhub-token";
        gitSigningKey = "${config.home.homeDirectory}/.ssh/id_ed25519_signing";
        slack.dmChannel = "U0B434JALCQ";
        slack.extraMentions = [ "U0B68ETVDFD" ];
      };
    };
}
