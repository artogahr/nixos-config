# Zed editor, shared across all hosts.
{ pkgs, inputs, ... }:
let
  zedPackage = inputs.zed.packages.${pkgs.system}.default.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      ln -sf $out/bin/zed $out/bin/zeditor
    '';
  });
in

{
  # The catppuccin module pins one flavor; we follow the system theme instead.
  catppuccin.zed.enable = false;

  programs.zed-editor = {
    enable = false;
    package = zedPackage;

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

    # Pin every language server to a Nix binary so nothing is downloaded at runtime.
    extraPackages = with pkgs; [
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
            command = "nixfmt";
            arguments = [ ];
          };
        };
        Typst.formatter.external = {
          command = "typstyle";
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
