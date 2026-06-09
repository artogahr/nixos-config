{ pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    # package = pkgs.evil-helix;
    defaultEditor = false;
    settings = {
      theme = lib.mkForce "catppuccin-frappe-transparent";
      editor.cursor-shape.insert = "bar";
      editor.line-number = "relative";
      editor.soft-wrap.enable = true;
    };
    themes = {
      "catppuccin-frappe-transparent" = {
        inherits = "catppuccin_frappe";
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
