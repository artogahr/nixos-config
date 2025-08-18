{ ... }:

{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      style = "auto";
      # invert = true;
      keymap_mode = "auto";
      enter_accept = true;
      update_check = false;
      show_help = false;
    };
  };
}
