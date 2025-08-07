# /nixos-config/home.nix
{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  # User-level packages. All your GUI apps and personal CLI tools go here.
  home.packages = with pkgs; [
    # Essentials from your old config
    tree
    anydesk
    gh
    delta
    helix
    neovim
    telegram-desktop
    htop      
    ripgrep  
    fd      
  ];

  # Managed program configurations
  programs.git = {
    enable = true;
    userName = "Arto Gahr";
    userEmail = "artogahr@gmail.com";
    extraConfig = {
      # https://jvns.ca/blog/2024/02/16/popular-git-config-options/
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;
      commit.verbose = true;
      rerere.enabled = true;
      help.autocorrect = "prompt";
      core.pager = "delta";
      core.editor = "nvim";
      diff.algorithm = "histogram";
      branch.sort = "-committerdate";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      ll = "ls -alh";
      # The alias to rebuild your entire system!
      nrs = "sudo nixos-rebuild switch --flake /nixos-config#fukurowl-pc && git -C /nixos-config commit -a";
    };
    plugins = [
      { name = "z"; src = pkgs.fishPlugins.z; }
    ];
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };

  # Let Home Manager manage its own configuration file
  programs.home-manager.enable = true;
}
