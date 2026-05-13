{ pkgs, ... }:

{
  # Additional Rust development tools (system already has core toolchain)
  home.packages = with pkgs; [
    # Cargo extensions for development workflow
    cargo-watch # Auto-rebuild on file changes: `cargo watch -x check`
    cargo-expand # Show macro expansions: `cargo expand`
    cargo-audit # Security vulnerability scanner: `cargo audit`
    cargo-outdated # Check for outdated dependencies: `cargo outdated`
    cargo-bloat # Find what's taking up space: `cargo bloat`
    cargo-flamegraph # Performance profiling: `cargo flamegraph`
    cargo-nextest # Faster test runner: `cargo nextest run`
    bacon # Background compiler: `bacon`
    cargo-edit # Add/remove dependencies: `cargo add`, `cargo rm`
    cargo-udeps # Find unused dependencies: `cargo udeps`
    cargo-machete # Remove unused dependencies: `cargo machete`
    cargo-generate

    # Cross-compilation helpers (useful for eBPF targets)
    cargo-zigbuild # Use Zig as linker for cross-compilation
  ];

  # # Development environment variables
  # home.sessionVariables = {
  #   # Always show backtraces in development
  #   RUST_BACKTRACE = "1";

  #   # Enable incremental compilation for faster builds
  #   CARGO_INCREMENTAL = "1";

  #   # Optimize for your specific CPU (faster local builds)
  #   RUSTFLAGS = "-C target-cpu=native";

  #   # Faster linking on Linux
  #   CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = "clang";
  #   CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS = "-C link-arg=-fuse-ld=lld";
  # };

  # # Shell aliases for common Rust development tasks
  # programs.fish.shellAliases = {
  #   # Quick cargo commands
  #   cb = "cargo build";
  #   cbr = "cargo build --release";
  #   ct = "cargo test";
  #   cc = "cargo check";
  #   cr = "cargo run";
  #   cf = "cargo fmt";

  #   # Enhanced development workflow
  #   cw = "cargo watch -x check -x test";          # Watch and check + test
  #   cwc = "cargo watch -x clippy";                # Watch and clippy
  #   cwr = "cargo watch -x 'run'";                 # Watch and run

  #   # Cargo extensions
  #   ca = "cargo audit";                           # Security audit
  #   co = "cargo outdated";                        # Check outdated deps
  #   cad = "cargo add";                            # Add dependency
  #   crm = "cargo remove";                         # Remove dependency

  #   # Performance and analysis
  #   cflame = "cargo flamegraph";                  # Generate flamegraph
  #   cblat = "cargo bloat --release --crates";    # Analyze binary size
  #   ctree = "cargo tree";                        # Show dependency tree

  #   # Testing
  #   cnt = "cargo nextest run";                    # Fast test runner
  #   ctr = "cargo test --release";                 # Release mode tests

  #   # eBPF specific (assuming xtask pattern)
  #   cbe = "cargo xtask build-ebpf";              # Build eBPF programs
  #   cre = "cargo xtask run";                     # Run with eBPF

  #   # Documentation
  #   cdoc = "cargo doc --open";                   # Build and open docs
  #   cdocr = "cargo doc --document-private-items --open"; # Include private items
  # };

  # Fish shell functions for advanced workflows
  # programs.fish.functions = {
  #   # Quick project setup
  #   rust-new = {
  #     body = ''
  #       cargo new $argv[1]
  #       cd $argv[1]
  #       echo "use flake" > .envrc
  #       git init
  #       echo "Created new Rust project: $argv[1]"
  #     '';
  #     description = "Create new Rust project with direnv";
  #   };

  #   # Quick dependency management
  #   rust-update = {
  #     body = ''
  #       echo "Updating dependencies..."
  #       cargo update
  #       echo "Checking for outdated dependencies..."
  #       cargo outdated
  #       echo "Running security audit..."
  #       cargo audit
  #     '';
  #     description = "Update and audit dependencies";
  #   };

  #   # Performance analysis
  #   rust-perf = {
  #     body = ''
  #       echo "Building release binary..."
  #       cargo build --release
  #       echo "Generating flamegraph..."
  #       cargo flamegraph --bin $argv[1]
  #       echo "Analyzing binary size..."
  #       cargo bloat --release --crates
  #     '';
  #     description = "Performance analysis for a binary";
  #   };

  #   # Clean and rebuild everything
  #   rust-fresh = {
  #     body = ''
  #       cargo clean
  #       cargo build
  #       cargo test
  #       cargo clippy
  #     '';
  #     description = "Fresh build with full checks";
  #   };
  # };

  # Git ignore patterns for Rust
  programs.git.ignores = [
    # Rust build artifacts
    "target/"
    "Cargo.lock" # Only ignore for applications, not libraries
    "*.pdb"

    # Flamegraph outputs
    "flamegraph.svg"
    "perf.data*"

    # eBPF outputs
    "*.o"
    "*.ll"
  ];
}
