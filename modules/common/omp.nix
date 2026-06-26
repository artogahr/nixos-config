# Configuration for oh-my-pi (omp) AI coding agent.
# Wired to local omlx inference server serving Apple Silicon MLX models.
{ ... }:
{
  # Configure custom models in models.yml
  home.file.".omp/agent/models.yml".text = ''
    providers:
      omlx:
        baseUrl: http://127.0.0.1:8000/v1
        apiKey: omlx-9qe8mz1liuovqqhz
        api: openai-completions
        discovery:
          type: openai-models-list
        models:
          - id: gemma-4-E4B-it-MLX-4bit
            name: Gemma 4 E4B (MLX, vision + tools)
            contextWindow: 131072
            maxTokens: 4096
          - id: gemma-4-26B-A4B-it-QAT-MLX-4bit
            name: Gemma 4 26B-A4B (MLX, MoE, QAT)
            contextWindow: 131072
            maxTokens: 4096
          - id: Qwen3.6-35B-A3B-MLX-4bit
            name: Qwen3.6 35B-A3B (MLX, MoE)
            reasoning: true
            contextWindow: 32768
            maxTokens: 8192
            compat:
              supportsReasoningEffort: true
              extraBody:
                reasoning_effort: high
          - id: Qwen3.6-27B-MLX-4bit
            name: Qwen3.6 27B (MLX, dense)
            reasoning: true
            contextWindow: 32768
            maxTokens: 8192
            compat:
              supportsReasoningEffort: true
              extraBody:
                reasoning_effort: high
  '';

  # Configure default settings in config.yml
  home.file.".omp/agent/config.yml".text = ''
    modelRoles:
      default: omlx/Qwen3.6-35B-A3B-MLX-4bit
      smol: omlx/gemma-4-E4B-it-MLX-4bit
      slow: omlx/Qwen3.6-35B-A3B-MLX-4bit
    modelProviderOrder:
      - omlx
      - ollama
    defaultThinkingLevel: high
  '';
}
