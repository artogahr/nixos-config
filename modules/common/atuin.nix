{ ... }:

{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      style = "auto";
      keymap_mode = "auto";
      enter_accept = true;
      update_check = false;
      show_help = false;
    };
    flags = [
      "--disable-up-arrow"
    ];
  };
}
