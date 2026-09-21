# Declaratively install AI agent skills for every agent.
#
# User-level skill directories, per upstream docs:
#   ~/.claude/skills      Claude Code (only path it reads)
#   ~/.agents/skills      Codex and opencode (the cross-agent convention)
#   ~/.kimi-code/skills   Kimi Code ($KIMI_CODE_HOME/skills)
# opencode also reads ~/.claude/skills, so it is covered twice; harmless.
{
  lib,
  pkgs,
  ...
}:
let
  skillDirs = [
    ".claude/skills"
    ".agents/skills"
    ".kimi-code/skills"
  ];

  # nixpkgs' installAgentSkills hook installs to $out/share/skills/<pname>/<skill>/;
  # see doc/hooks/installAgentSkills.section.md.
  fromPackage =
    pkg: base: skill:
    "${pkg}/share/skills/${base}/${skill}";

  skillSources = {
    herdr = fromPackage pkgs.herdr "herdr" "herdr";
  };

  # A home.file source that does not resolve produces a dangling symlink, and every
  # agent skips those without a word. Wrap each source so a wrong path fails the
  # build instead — same trick home-manager's claude-code module uses internally.
  checked =
    name: src:
    pkgs.runCommandLocal "agent-skill-${name}" { } ''
      test -f ${lib.escapeShellArg src}/SKILL.md \
        || { echo "skill '${name}': no SKILL.md under ${src}" >&2; exit 1; }
      ln -s ${lib.escapeShellArg src} "$out"
    '';

  checkedSources = lib.mapAttrs checked skillSources;
in
{
  home.file = lib.listToAttrs (
    lib.concatMap (
      dir:
      lib.mapAttrsToList (
        name: source: lib.nameValuePair "${dir}/${name}" { inherit source; }
      ) checkedSources
    ) skillDirs
  );
}
