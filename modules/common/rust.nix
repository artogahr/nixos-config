{ pkgs, inputs, ... }:
let
  rust = inputs.fenix.packages.${pkgs.system}.stable;
in
{
  home.packages =
    [
      (rust.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
        "rust-analyzer"
      ])
    ]
    ++ (with pkgs; [
      cargo-watch
      cargo-expand
      cargo-audit
      cargo-outdated
      cargo-bloat
      cargo-flamegraph
      cargo-nextest
      bacon
      cargo-edit
      cargo-udeps
      cargo-machete
      cargo-generate
      cargo-zigbuild
    ]);

  programs.git.ignores = [
    "target/"
    "*.pdb"
    "flamegraph.svg"
    "perf.data*"
  ];
}
