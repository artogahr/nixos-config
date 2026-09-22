{
  config,
  lib,
  pkgs,
  ...
}:
let
  configFile = ".codex/config.toml";

  mergeConfig =
    pkgs.writers.writePython3 "codex-config-merge"
      {
        libraries = [ pkgs.python3Packages.tomli-w ];
      }
      ''
        import os
        import sys
        import tomllib

        import tomli_w

        seed_path, target = sys.argv[1], sys.argv[2]


        def merge(base, over):
            out = dict(base)
            for key, value in over.items():
                if isinstance(value, dict) and isinstance(out.get(key), dict):
                    out[key] = merge(out[key], value)
                else:
                    out[key] = value
            return out


        with open(seed_path, "rb") as f:
            seed = tomllib.load(f)
        existing = {}
        if os.path.exists(target):
            with open(target, "rb") as f:
                existing = tomllib.load(f)
        if os.path.islink(target):
            os.remove(target)
        tmp = target + ".tmp"
        with open(tmp, "wb") as f:
            tomli_w.dump(merge(existing, seed), f)
        os.replace(tmp, target)
      '';
in
{
  programs.codex = {
    enable = true;
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
            "@suthio/redash-mcp"
          ];
          env.REDASH_URL = "https://charts.apify.com";
          env_vars = [ "REDASH_API_KEY" ];
        };
        notion.url = "https://mcp.notion.com/mcp";
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

  # Codex writes runtime state to config.toml, so keep it writable.
  # Nix settings override existing keys; removed settings remain in the file.
  home.file.${configFile}.enable = false;
  home.activation.codexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${mergeConfig} ${config.home.file.${configFile}.source} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/${configFile}"}
  '';
}
