{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Arto Gahr";
      user.email = "artogahr@gmail.com";
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push.autoSetupRemote = true;
      commit.verbose = true;
      rerere.enabled = true;
      help.autocorrect = "prompt";
      core.pager = "delta";
      core.editor = "hx";
      diff.algorithm = "histogram";
      branch.sort = "-committerdate";
    };
  };
}
