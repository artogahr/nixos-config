# OpenCode uses the native OpenRouter catalog through the Apify relay.
# omlx remains available on macOS.
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
    provider = {
      openrouter.options = {
        baseURL = "https://artogahr--openrouter-relay.apify.actor/api/v1";
        apiKey = "{file:${config.sops.secrets.apify-token.path}}";
      };
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      omlx = {
        npm = "@ai-sdk/openai-compatible";
        name = "omlx (MLX)";
        options.baseURL = "http://localhost:8000/v1";
        options.apiKey = "omlx-9qe8mz1liuovqqhz";
        models = {
          "gemma-4-E4B-it-MLX-4bit" = {
            name = "Gemma 4 E4B (MLX, vision + tools)";
          };
          "gemma-4-26B-A4B-it-QAT-MLX-4bit" = {
            name = "Gemma 4 26B-A4B (MLX, MoE, QAT)";
          };
          "Qwen3.6-35B-A3B-MLX-4bit" = {
            name = "Qwen3.6 35B-A3B (MLX, MoE)";
            options.reasoning_effort = "high";
            reasoning = true;
          };
          "Qwen3.6-27B-MLX-4bit" = {
            name = "Qwen3.6 27B (MLX, dense)";
            options.reasoning_effort = "high";
            reasoning = true;
          };
        };
      };
    };
    model =
      if pkgs.stdenv.hostPlatform.isDarwin then
        "omlx/Qwen3.6-35B-A3B-MLX-4bit"
      else
        "openrouter/openrouter/auto";
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

  };
}
