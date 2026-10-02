{ pkgs, config, ... }:
{
  home.packages = [ pkgs.pi-coding-agent ];

  home.file.".pi/agent/models.json".text = builtins.toJSON {
    providers.openrouter = {
      baseUrl = "https://artogahr--openrouter-relay.apify.actor/api/v1";
      apiKey = "!cat ${config.sops.secrets.apify-token.path}";
    };
  };
}
