{ ... }:

{
  # The skill herdr ships is linked into every agent's skill dir by skills.nix.
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
