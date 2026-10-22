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
        apifyTokenFile = config.sops.secrets.apify-token.path;
        mezmoKeyFile = config.sops.secrets.mezmo-api-key.path;
        apifyOrgTokenFile = "${config.home.homeDirectory}/.config/artomatic/org-token";
        slack.dmChannel = "U0B434JALCQ";
        slack.extraMentions = [ "U0B68ETVDFD" ];
        homeAssistant = {
          url = "http://10.0.0.5:8123";
          tokenFile = config.sops.secrets.homeassistant-token.path;
          notifyService = "mobile_app_galaxy_s24";
        };
      };
    };
}
