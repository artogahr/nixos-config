# Declaratively install AI agent skills from multiple sources, for every agent.
#
# User-level skill directories, per upstream docs:
#   ~/.claude/skills      Claude Code (only path it reads)
#   ~/.agents/skills      Codex and opencode (the cross-agent convention)
#   ~/.kimi-code/skills   Kimi Code ($KIMI_CODE_HOME/skills)
# opencode also reads ~/.claude/skills, so it is covered twice; harmless.
#
# Bump any source with `nix flake update <input-name>`.
{
  inputs,
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

  # --- Matt Pocock's skills ---
  # Source: github:mattpocock/skills
  # Each skill lives at skills/<category>/<name>/SKILL.md upstream; flatten to <name>/.
  # Skip deprecated/, in-progress/, personal/ — only ship the stable sets.
  mpSrc = inputs.mattpocock-skills;
  mpCategories = [
    "engineering"
    "productivity"
    "misc"
  ];
  mpSkillsFor =
    cat:
    let
      dir = "${mpSrc}/skills/${cat}";
    in
    lib.mapAttrs (name: _: "${dir}/${name}") (
      lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)
    );

  # --- Skills shipped inside nixpkgs packages ---
  # nixpkgs' installAgentSkills hook installs to $out/share/skills/<pname>/<skill>/;
  # see doc/hooks/installAgentSkills.section.md.
  fromPackage =
    pkg: base: skill:
    "${pkg}/share/skills/${base}/${skill}";

  pkgSkills = {
    herdr = fromPackage pkgs.herdr "herdr" "herdr";
  };

  skillSources = lib.foldl' (acc: cat: acc // mpSkillsFor cat) { } mpCategories // pkgSkills;

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
