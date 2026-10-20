{ pkgs, ... }:
let
  aiTells = pkgs.fetchzip {
    url = "https://github.com/tbhb/vale-ai-tells/releases/download/v1.37.0/ai-tells.zip";
    hash = "sha256-c8J9B6sv4DlEpI3w6jVik8ughU3iqyc8X5IJZnhr1v4=";
  };
  aiTellsCommits = pkgs.fetchzip {
    url = "https://github.com/tbhb/vale-ai-tells/releases/download/v1.37.0/ai-tells-commits.zip";
    hash = "sha256-/Nh8arcWAvy1ViNmXuTlY7hH6gcImMWiEeEX7YxONTc=";
  };
  styles = pkgs.linkFarm "ai-check-vale-styles" {
    ai-tells = "${aiTells}/styles/ai-tells";
    ai-tells-commits = aiTellsCommits;
    "ai-check/Dashes.yml" = ./ai-check/Dashes.yml;
    "ai-check/Colons.yml" = ./ai-check/Colons.yml;
  };

  prose = ''
    ai-tells.EmDashUsage = YES
    ai-tells.ConsequenceClause = YES
    ai-tells.ContrastiveNegation = YES
    ai-tells.ContrastiveFormulas = YES
    ai-tells.NegatedPair = YES
  '';
  # ai-check.sh writes code comments to .markdown files, Markdown and gh text to .md and commit messages to .txt.
  valeIni = pkgs.writeText "ai-check-vale.ini" ''
    StylesPath = ${styles}
    MinAlertLevel = error

    [*.markdown]
    ${prose}

    [*.md]
    ${prose}
    ai-check.Dashes = YES
    ai-check.Colons = YES
    ai-tells.LabelAndExplain = YES

    [*.txt]
    ${prose}
    ai-check.Dashes = YES
    ai-tells-commits.CommitPastTense = YES
    ai-tells-commits.CommitSelfReference = YES
  '';

  aiCheck = pkgs.writeShellApplication {
    name = "ai-check";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      git
      gnused
      jq
      vale
    ];
    runtimeEnv.VALE_INI = valeIni;
    text = builtins.readFile ./ai-check/ai-check.sh;
  };

  ghShim = pkgs.writeShellScript "gh" ''
    case " $* " in
      *" pr "* | *" issue "* | *" api "*) ${aiCheck}/bin/ai-check gh "$@" || exit 1 ;;
    esac
    exec ${pkgs.gh}/bin/gh "$@"
  '';

  workRepos =
    [ "gitdir:~/workplace/apify/" ]
    ++ map (org: "hasconfig:remote.*.url:${org}/**") [
      "git@github.com:apify"
      "git@github.com:apify-store"
      "https://github.com/apify"
      "https://github.com/apify-store"
    ];
in
{
  # Hooks set in git config (git 2.54+) also run in repos that set core.hooksPath.
  programs.git.includes = map (condition: {
    inherit condition;
    contents.hook.ai-check-msg = {
      event = "commit-msg";
      command = "${aiCheck}/bin/ai-check commit-msg";
    };
  }) workRepos;

  programs.gh.package = pkgs.symlinkJoin {
    name = "gh-ai-check";
    paths = [ pkgs.gh ];
    postBuild = "ln -sf ${ghShim} $out/bin/gh";
    meta.mainProgram = "gh";
  };
}
