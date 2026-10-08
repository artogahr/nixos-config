# OpenCode uses the native OpenRouter catalog through the Apify relay.
{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    instructions = [
      "${config.home.homeDirectory}/.claude/ai-guidelines.md"
      "${config.home.homeDirectory}/.claude/writing.md"
    ];
    "$schema" = "https://opencode.ai/config.json";
    provider.openrouter.options = {
      baseURL = "https://artogahr--openrouter-relay.apify.actor/api/v1";
      apiKey = "{file:${config.sops.secrets.apify-token.path}}";
    };
    mcp.notion = {
      type = "remote";
      url = "https://mcp.notion.com/mcp";
      enabled = true;
    };
    mcp.apify = {
      type = "remote";
      url = "https://mcp.apify.com";
      enabled = true;
    };
    # Credentials come from env vars exported by secrets.nix (private nix-secrets repo).
    mcp.home-assistant = {
      type = "local";
      command = [
        (lib.getExe' pkgs.uv "uvx")
        "ha-mcp"
      ];
      environment = {
        HOMEASSISTANT_URL = "http://10.0.0.5:8123";
        HOMEASSISTANT_TOKEN = "{env:HOMEASSISTANT_TOKEN}";
      };
      enabled = true;
    };
    mcp.mezmo = {
      type = "remote";
      url = "https://mcp.mezmo.com/mcp";
      headers.Authorization = "Bearer {env:MEZMO_API_KEY}";
      enabled = true;
    };
    mcp.langfuse = {
      type = "remote";
      url = "https://langfuse.apify.dev/api/public/mcp";
      headers.Authorization = "{env:LANGFUSE_AUTH}";
      enabled = true;
    };

  };
}
