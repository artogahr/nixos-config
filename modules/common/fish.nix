{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    # Cross-platform aliases only. OS-specific rebuild aliases (`nrs`, `nos`) live in
    # modules/linux/home/fish-aliases.nix and modules/darwin/home/fish-aliases.nix.
    shellAliases = {
      ".." = "cd ..";
      ll = "ls -alh";
    };
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
    ];
    interactiveShellInit = ''
      set -g fish_greeting
      set -gx NIXPKGS_ALLOW_UNFREE 1
      set -gx NIXPKGS_ALLOW_INSECURE 1
      fish_add_path "$HOME/.local/bin"
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
