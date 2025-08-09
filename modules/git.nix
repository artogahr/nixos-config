{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Arto Gahr";
    userEmail = "artogahr@gmail.com";
    extraConfig = {
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
}
