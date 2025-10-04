{ pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    # package = pkgs.evil-helix;
    defaultEditor = false;
    settings = {
      theme = lib.mkForce "catppuccin-mocha-transparent";
      editor.cursor-shape.insert = "bar";
      editor.line-number = "relative";
      editor.soft-wrap.enable = true;
    };
    themes = {
      "catppuccin-mocha-transparent" = {
        # Inherit all other styles from the original catppuccin-mocha theme
        inherits = "catppuccin-mocha";
        # Set the UI background to be transparent by leaving it empty
        "ui.background" = { };
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
      {
        name = "typst";
        auto-format = true;
        formatter.command = "${pkgs.typstyle}/bin/typstyle";
      }
    ];
  };
}
