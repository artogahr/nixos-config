# Cross-platform home-manager baseline.
# Shared by every host (NixOS and nix-darwin).
{
  pkgs,
  lib,
  config,
  ...
}:
let
  aiGuidelines = ./ai-guidelines.md;
in
{
  home.stateVersion = "25.05";

  manual.manpages.enable = false;

  programs.home-manager.enable = true;
  programs.uv.enable = true;

  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  catppuccin.flavor = "frappe";
  catppuccin.fish.enable = false;
  catppuccin.nvim.enable = false;

  home.packages = with pkgs; [
    bat
    btop
    direnv
    zellij
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".claude/ai-guidelines.md" = {
    source = aiGuidelines;
    force = true;
  };
  home.file.".claude/CLAUDE.md" = {
    text = "@ai-guidelines.md\n";
    force = true;
  };

  home.file."${config.home.homeDirectory}/.claude/settings.json".force = true;
  programs.claude-code = {
    enable = true;
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
      # Unused in the last 9 days / 50 sessions across all projects (2026-08-12 doctor run).
      # Remove an entry (or delete the whole block) to re-enable that skill.
      skillOverrides = {
        "code-review" = "off";
        "diagnosing-bugs" = "off";
        "grilling" = "off";
        "resolving-merge-conflicts" = "off";
        "tdd" = "off";
      };
      permissions = {
        defaultMode = "auto";
        deny = [ "AskUserQuestion" ];
        ask = [
          "Bash(git push *)"
          "Bash(gh pr create *)"
        ];
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
