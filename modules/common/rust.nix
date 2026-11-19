{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cargo
    clippy
    rustc
    rustfmt
    rust-analyzer
    cargo-expand
    cargo-audit
    cargo-bloat
    cargo-flamegraph
    cargo-nextest
    bacon
    cargo-edit
    cargo-udeps
    cargo-machete
    cargo-zigbuild
  ];

  programs.git.ignores = [
    "target/"
    "*.pdb"
    "flamegraph.svg"
    "perf.data*"
  ];
}
