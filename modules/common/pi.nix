{
  pkgs,
  config,
  lib,
  ...
}:
{
  # agent-browser is the upstream CLI pi-agent-browser-native drives. It needs Pi
  # 1.0.0 or newer; nixpkgs ships 0.99.2, so the browser tools stay inert for now.
  home.packages = [
    pkgs.pi-coding-agent
    pkgs.agent-browser
  ];

  home.file.".pi/agent/AGENTS.md".text =
    builtins.readFile ./ai-guidelines.md + builtins.readFile ./writing.md;

  home.file.".pi/agent/models.json".text = builtins.toJSON {
    providers.openrouter = {
      baseUrl = "https://artogahr--openrouter-relay.apify.actor/api/v1";
      apiKey = "!cat ${config.sops.secrets.apify-token.path}";
    };
  };

  # Same servers as the other agents. Secrets come from the environment
  # (REDASH_API_KEY, HOMEASSISTANT_TOKEN, MEZMO_API_KEY, exported by secrets.nix),
  # not stored in this repo. Notion and Apify use OAuth: run
  # `pi mcp login <server>` once per host.
  home.file.".pi/agent/mcp.json".text = builtins.toJSON {
    mcpServers = {
      redash = {
        command = lib.getExe' pkgs.nodejs "npx";
        args = [
          "-y"
          "@suthio/redash-mcp"
        ];
        env = {
          REDASH_URL = "https://charts.apify.com";
          REDASH_API_KEY = "\${REDASH_API_KEY}";
        };
      };
      notion.url = "https://mcp.notion.com/mcp";
      apify.url = "https://mcp.apify.com";
      "home-assistant" = {
        command = lib.getExe' pkgs.uv "uvx";
        args = [ "ha-mcp" ];
        env = {
          HOMEASSISTANT_URL = "http://10.0.0.5:8123";
          HOMEASSISTANT_TOKEN = "\${HOMEASSISTANT_TOKEN}";
        };
      };
      mezmo = {
        url = "https://mcp.mezmo.com/mcp";
        headers.Authorization = "Bearer \${MEZMO_API_KEY}";
      };
    };
  };
}
