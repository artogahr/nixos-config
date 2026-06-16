# Cross-platform local AI coding agent (OpenCode) wired to local OpenAI-compatible backends:
#   - Ollama on :11434 (macOS: ollama-app cask; Linux: services.ollama, see modules/linux/nixos/ollama.nix).
#   - omlx on :8000 (macOS only), an Apple Silicon MLX inference server (`omlx start`).
# Pull/load a model before first use, e.g. `ollama pull gemma4:31b` or fetch it via omlx.
{ pkgs, ... }:
{
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider.ollama = {
      npm = "@ai-sdk/openai-compatible";
      name = "Ollama (local)";
      options.baseURL = "http://localhost:11434/v1";
      # OpenCode does not auto-discover Ollama's installed models for a custom
      # provider; every model usable from the picker must be listed here.
      models = {
        "gemma4:31b" = {
          name = "Gemma 4 31B (dense)";
        };
        "gemma4:26b" = {
          name = "Gemma 4 26B (MoE, fast)";
        };
        "qwen3.6:35b-a3b" = {
          name = "Qwen3.6 35B-A3B (MoE)";
          # /v1 ignores Ollama's native `think`; reasoning_effort is the OpenAI-compatible lever.
          options.reasoning_effort = "high";
          reasoning = true;
        };
        "qwen3-coder:30b" = {
          name = "Qwen3 Coder 30B";
        };
      };
    };
    # omlx serves these MLX models on Apple Silicon. Model keys are omlx's directory
    # names (or aliases) — confirm with `curl http://localhost:8000/v1/models`.
    provider.omlx = {
      npm = "@ai-sdk/openai-compatible";
      name = "omlx (MLX)";
      options.baseURL = "http://localhost:8000/v1";
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
  };
}
