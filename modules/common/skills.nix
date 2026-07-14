# Declaratively install AI agent skills from multiple sources.
# Both ~/.claude/skills and ~/.agents/skills are auto-loaded by opencode;
# ~/.claude/skills is also read by Claude Code.
# Bump any source with `nix flake update <input-name>`.
{ inputs, lib, ... }:
let
  # --- Matt Pocock's skills → ~/.claude/skills/<name>/ ---
  # Source: github:mattpocock/skills
  # Each skill lives at skills/<category>/<name>/SKILL.md upstream; flatten to
  # ~/.claude/skills/<name>/ so Claude Code and opencode discover them.
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
      skillDirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir);
    in
    lib.mapAttrs' (
      name: _:
      lib.nameValuePair ".claude/skills/${name}" {
        source = "${dir}/${name}";
      }
    ) skillDirs;
in
{
  home.file = lib.mkMerge (map mpSkillsFor mpCategories);
}
