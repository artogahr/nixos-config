# Karabiner-Elements config. The app comes from the Homebrew cask (modules/darwin/nix-darwin/homebrew.nix).
# Changes made in the Karabiner UI fail because the config is read-only.
{ pkgs, ... }:
let
  whileCaps = from: to: {
    type = "basic";
    conditions = [
      {
        type = "variable_if";
        name = "caps_lock pressed";
        value = 1;
      }
    ];
    from = {
      key_code = from;
      modifiers.optional = [ "any" ];
    };
    to = [ to ];
  };
in
{
  # Karabiner watches the directory, so a symlink to the file alone is not reloaded.
  xdg.configFile."karabiner".source = pkgs.writeTextDir "karabiner.json" (
    builtins.toJSON {
      global.show_in_menu_bar = false;
      profiles = [
        {
          name = "Default profile";
          selected = true;
          virtual_hid_keyboard.keyboard_type_v2 = "ansi";
          fn_function_keys = [
            {
              from.key_code = "f6";
              to = [ { apple_vendor_keyboard_key_code = "launchpad"; } ];
            }
          ];
          complex_modifications.rules = [
            {
              description = "CAPS+A › CAPS";
              manipulators = [ (whileCaps "a" { key_code = "caps_lock"; }) ];
            }
            {
              description = "CAPS+↩︎ › CAPS";
              manipulators = [ (whileCaps "return_or_enter" { key_code = "caps_lock"; }) ];
            }
            {
              description = "CAPS › ESC, CAPS+H/J/K/L › ←↓↑→";
              manipulators = [
                (whileCaps "j" { key_code = "down_arrow"; })
                (whileCaps "k" { key_code = "up_arrow"; })
                (whileCaps "h" { key_code = "left_arrow"; })
                (whileCaps "l" { key_code = "right_arrow"; })
                {
                  type = "basic";
                  from = {
                    key_code = "caps_lock";
                    modifiers.optional = [ "any" ];
                  };
                  to = [
                    {
                      set_variable = {
                        name = "caps_lock pressed";
                        value = 1;
                      };
                    }
                  ];
                  to_after_key_up = [
                    {
                      set_variable = {
                        name = "caps_lock pressed";
                        value = 0;
                      };
                    }
                  ];
                  to_if_alone = [ { key_code = "escape"; } ];
                }
              ];
            }
            {
              # Sends the macOS "Move left/right a space" shortcuts.
              description = "CAPS+U/I › previous/next desktop";
              manipulators = [
                (whileCaps "u" {
                  key_code = "left_arrow";
                  modifiers = [ "left_control" ];
                })
                (whileCaps "i" {
                  key_code = "right_arrow";
                  modifiers = [ "left_control" ];
                })
              ];
            }
            {
              description = "Mac OSX: disable cmd + option + h + m to prevent minimising all windows";
              enabled = false;
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "h";
                    modifiers = {
                      mandatory = [
                        "command"
                        "option"
                      ];
                      optional = [ "any" ];
                    };
                  };
                }
                {
                  type = "basic";
                  from = {
                    key_code = "m";
                    modifiers = {
                      mandatory = [
                        "command"
                        "option"
                      ];
                      optional = [ "any" ];
                    };
                  };
                }
              ];
            }
            {
              description = "Mac OSX: disable cmd + h to prevent minimising an application window";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "h";
                    modifiers.mandatory = [ "command" ];
                  };
                }
              ];
            }
            {
              description = "F6 to Ctrl+Option+Cmd+K";
              manipulators = [
                {
                  type = "basic";
                  from.key_code = "f6";
                  to = [
                    {
                      key_code = "k";
                      modifiers = [
                        "left_control"
                        "left_option"
                        "left_command"
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    }
  );
}
