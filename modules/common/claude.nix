# Claude Code settings, MCP servers and the instruction files in ~/.claude.
# opencode.nix also reads the guides from ~/.claude.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  aiGuidelines = ./ai-guidelines.md;
  writingGuide = ./writing.md;
in
{
  home.file.".claude/ai-guidelines.md" = {
    source = aiGuidelines;
    force = true;
  };
  home.file.".claude/writing.md" = {
    source = writingGuide;
    force = true;
  };
  home.file.".claude/CLAUDE.md" = {
    text = builtins.readFile aiGuidelines + "\n" + builtins.readFile writingGuide;
    force = true;
  };

  home.file."${config.home.homeDirectory}/.claude/settings.json".force = true;
  programs.claude-code = {
    enable = true;
    mcpServers.redash = {
      type = "stdio";
      command = lib.getExe' pkgs.nodejs "npx";
      args = [
        "-y"
        "@suthio/redash-mcp@0.0.15" # 0.0.16 crashes: imports zod/v4, which zod 4.6 dropped
      ];
      env = {
        REDASH_URL = "https://charts.apify.com";
        REDASH_API_KEY = "\${REDASH_API_KEY}";
      };
    };
    # Credentials come from env vars exported by secrets.nix (private nix-secrets repo).
    mcpServers.home-assistant = {
      type = "stdio";
      command = lib.getExe' pkgs.uv "uvx";
      args = [ "ha-mcp" ];
      env = {
        HOMEASSISTANT_URL = "http://10.0.0.5:8123";
        HOMEASSISTANT_TOKEN = "\${HOMEASSISTANT_TOKEN}";
      };
    };
    mcpServers.mezmo = {
      type = "http";
      url = "https://mcp.mezmo.com/mcp";
      headers.Authorization = "Bearer \${MEZMO_API_KEY}";
    };
    mcpServers.langfuse = {
      type = "http";
      url = "https://langfuse.apify.dev/api/public/mcp";
      headers.Authorization = "\${LANGFUSE_AUTH}";
    };
    settings = {
      # model = "claude-fable-5[1m]";
      enabledPlugins = {
        # "superpowers@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = false;
        "initialize-typescript-repo@apify-agent-skills-internal" = false;
        # "principal-review@apify-agent-skills-internal" = true;
        # "staff-review@apify-agent-skills-internal" = true;
        # "apify-prophet@apify-agent-skills-internal" = true;
      };
      permissions = {
        defaultMode = "auto";
        deny = [ "AskUserQuestion" ];
      };
      extraKnownMarketplaces = {
        apify-agent-skills-internal = {
          source = {
            source = "git";
            url = "git@github.com:apify/agent-skills-internal.git";
          };
          autoUpdate = true;
        };
      };
      attribution = {
        commit = "";
        pr = "";
      };
      # herdr agent-state integration. The script is installed and version-bumped
      # imperatively by `herdr integration install claude`; only this invocation
      # lives in nix because settings.json is a read-only store symlink.
      hooks.SessionStart = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = "bash '${config.home.homeDirectory}/.claude/hooks/herdr-agent-state.sh' session";
              timeout = 10;
            }
          ];
        }
      ];
      effortLevel = "high";
      skipDangerousModePermissionPrompt = true;
      skipWorkflowUsageWarning = true;
      theme = "auto";
      inputNeededNotifEnabled = true;
      agentPushNotifEnabled = true;
      skipAutoPermissionPrompt = true;
    };
  };
}
