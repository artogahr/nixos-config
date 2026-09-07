# Declaratively install AI agent skills from multiple sources.
# The same set is linked into ~/.claude/skills (Claude Code) and ~/.agents/skills
# (Codex, opencode).
# Bump any source with `nix flake update <input-name>`.
{ inputs, lib, ... }:
let
  skillDirs = [
    ".claude/skills"
    ".agents/skills"
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

  skillSources = lib.foldl' (acc: cat: acc // mpSkillsFor cat) { } mpCategories;
in
{
  home.file = lib.listToAttrs (
    lib.concatMap (
      dir:
      lib.mapAttrsToList (
        name: source: lib.nameValuePair "${dir}/${name}" { inherit source; }
      ) skillSources
    ) skillDirs
  );
}
