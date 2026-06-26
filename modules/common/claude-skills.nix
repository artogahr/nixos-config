# Declaratively install Matt Pocock's agent skills (github:mattpocock/skills)
# into ~/.claude/skills, the replacement for `npx skills@latest add mattpocock/skills`.
# Each skill lives at skills/<category>/<name>/SKILL.md upstream; Claude Code expects
# them flattened at ~/.claude/skills/<name>/, so we symlink each skill dir individually.
# Bump the input with `nix flake update mattpocock-skills` to pull new/changed skills.
{ inputs, lib, ... }:
let
  src = inputs.mattpocock-skills;

  # Skip deprecated/, in-progress/, personal/ — only ship the stable sets.
  categories = [
    "engineering"
    "productivity"
    "misc"
  ];

  skillsFor =
    cat:
    let
      dir = "${src}/skills/${cat}";
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
  home.file = lib.mkMerge (map skillsFor categories);
}
