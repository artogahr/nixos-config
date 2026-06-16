# Local LLM backend for Linux hosts. Serves the OpenAI-compatible API on :11434
# that modules/common/opencode.nix talks to.
# Acceleration and auto-pulled models are left to each host (GPU varies):
#   see hosts/fukurowl-pc (ROCm) for the desktop's overrides.
{ ... }:
{
  services.ollama.enable = true;
}
