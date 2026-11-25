{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.codex = {
    enable = true;
    # Codex writes runtime state, such as project trust, to config.toml.
    mutableSettings = true;
    context =
      builtins.readFile ./ai-guidelines.md
      + builtins.readFile ./writing.md
      + ''

        For Apify-related access, use the Apify CLI; before using it, run `apify help --skill` and read its output.
      '';
    settings = {
      model_reasoning_effort = "high";
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;
      tui.notifications = true;
      features.hooks = true;
      mcp_servers = {
        redash = {
          command = "npx";
          args = [
            "-y"
            "@suthio/redash-mcp@0.0.15" # 0.0.16 crashes: imports zod/v4, which zod 4.6 dropped
          ];
          env.REDASH_URL = "https://charts.apify.com";
          env_vars = [ "REDASH_API_KEY" ];
        };
        notion.url = "https://mcp.notion.com/mcp";
        home-assistant = {
          command = lib.getExe' pkgs.uv "uvx";
          args = [ "ha-mcp" ];
          env.HOMEASSISTANT_URL = "http://10.0.0.5:8123";
          env_vars = [ "HOMEASSISTANT_TOKEN" ];
        };
        mezmo = {
          url = "https://mcp.mezmo.com/mcp";
          bearer_token_env_var = "MEZMO_API_KEY";
        };
        langfuse = {
          url = "https://langfuse.apify.dev/api/public/mcp";
          env_http_headers.Authorization = "LANGFUSE_AUTH";
        };
      };
    };
    # Install the hook script with `herdr integration install codex`.
    hooks.SessionStart = [
      {
        hooks = [
          {
            type = "command";
            command = "bash '${config.home.homeDirectory}/.codex/herdr-agent-state.sh' session";
            timeout = 10;
          }
        ];
      }
    ];
  };
}
