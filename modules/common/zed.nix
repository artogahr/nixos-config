# Zed editor, shared across all hosts. On Linux the binary comes from
# nixpkgs; the nix-built Zed on macOS can't install extensions, so there
# the Homebrew cask ships the binary and this module only manages config.
{ pkgs, lib, ... }:
let
  inherit (pkgs.stdenv) isDarwin;

  # Pin every language server to a Nix binary so nothing is downloaded at runtime.
  lspPackages = with pkgs; [
    nixd
    nixfmt
    prettierd
    tinymist
    typstyle
    rust-analyzer
    rustfmt
    vtsls
    basedpyright
    ruff
  ];
in

{
  # The catppuccin module pins one flavor; we follow the system theme instead.
  catppuccin.zed.enable = false;

  # extraPackages requires a non-null package, so on darwin go through PATH.
  # The fenix toolchain in rust.nix already ships rustfmt + rust-analyzer.
  home.packages = lib.optionals isDarwin (
    lib.subtractLists [
      pkgs.rust-analyzer
      pkgs.rustfmt
    ] lspPackages
  );

  home.shellAliases = if isDarwin then { zeditor = "zed"; } else { zed = "zeditor"; };

  programs.zed-editor = {
    enable = true;
    package = if isDarwin then null else pkgs.zed-editor;
    extraPackages = lib.optionals (!isDarwin) lspPackages;

    extensions = [
      "zed-catppuccin-blur"
      "nix"
      "typst"
      "toml"
      "html"
      "git_firefly"
      "zed-icons"
      "zed-xml"
      "zed-log"
    ];

    userSettings = {
      theme = {
        mode = "system";
        light = "Catppuccin Latte (Blur) [Heavy]";
        dark = "Catppuccin Frappé (Blur) [Heavy]";
      };

      vim_mode = true;
      relative_line_numbers = true;
      soft_wrap = "editor_width";
      scroll_beyond_last_line = "vertical_scroll_margin";

      session.trust_all_worktrees = true;
      active_pane_modifiers.inactive_opacity = 0.9;

      # Keep Vim yanks out of the OS clipboard; use cmd+c / cmd+v for that.
      vim.use_system_clipboard = "never";

      inlay_hints.enabled = false;
      git.inline_blame.enabled = true;

      terminal.shell.program = "fish";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      languages = {
        TypeScript.formatter.external = {
          command = "${pkgs.prettierd}/bin/prettierd";
          arguments = [ "{buffer_path}" ];
        };
        JavaScript.formatter.external = {
          command = "${pkgs.prettierd}/bin/prettierd";
          arguments = [ "{buffer_path}" ];
        };

        # The nix extension defaults to `nil`; opt into nixd + nixfmt instead.
        Nix = {
          language_servers = [ "nixd" ];
          formatter.external = {
            command = lib.getExe pkgs.nixfmt;
            arguments = [ ];
          };
        };
        Typst.formatter.external = {
          command = lib.getExe pkgs.typstyle;
          arguments = [ ];
        };
      };

      lsp = {
        nixd.binary.path = "${pkgs.nixd}/bin/nixd";
        rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        vtsls.binary = {
          path = "${pkgs.vtsls}/bin/vtsls";
          arguments = [ "--stdio" ];
        };
        basedpyright.binary = {
          path = "${pkgs.basedpyright}/bin/basedpyright-langserver";
          arguments = [ "--stdio" ];
        };
        ruff.binary = {
          path = "${pkgs.ruff}/bin/ruff";
          arguments = [ "server" ];
        };
      };
    };
  };
}
