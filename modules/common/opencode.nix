# Cross-platform local AI coding agent (OpenCode) wired to local OpenAI-compatible backends:
#   - omlx on :8000 (macOS only), an Apple Silicon MLX inference server (`omlx start`).
{ pkgs, config, ... }:
{
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    instructions = [ "${config.home.homeDirectory}/.claude/ai-guidelines.md" ];
    "$schema" = "https://opencode.ai/config.json";
    # omlx serves these MLX models on Apple Silicon. Model keys are omlx's directory
    # names (or aliases) — confirm with `curl http://localhost:8000/v1/models`.
    provider.omlx = {
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
    model = "omlx/Qwen3.6-35B-A3B-MLX-4bit";
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
