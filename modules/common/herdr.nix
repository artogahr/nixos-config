{ pkgs, ... }:

{
  # The herdr package ships the agent skill (pane/prompt/wait coordination);
  # expose it where Claude Code (+ opencode) and Kimi auto-discover skills.
  home.file.".claude/skills/herdr".source = "${pkgs.herdr}/share/herdr/skills/herdr";
  home.file.".kimi-code/skills/herdr".source = "${pkgs.herdr}/share/herdr/skills/herdr";

  programs.herdr = {
    enable = true;
    settings = {
      # herdr writes onboarding = false to its own config after first-run setup;
      # set it here since the managed config is a read-only store symlink
      onboarding = false;
      theme = {
        name = "catppuccin-latte";
        auto_switch = false;
      };
      ui.agent_panel_sort = "priority";
    };
  };
}
