# Declaratively install AI agent skills from multiple sources.
# Both ~/.claude/skills and ~/.agents/skills are auto-loaded by opencode;
# ~/.claude/skills is also read by Claude Code.
# Bump any source with `nix flake update <input-name>`.
{ inputs, lib, pkgs, ... }:
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

  # --- Understand-Anything plugin + skills ---
  # Source: github:Egonex-AI/Understand-Anything
  #
  # The Nix store is read-only, but the plugin needs writable node_modules
  # and compiled dist/ for its core package.  Instead of symlinking the
  # raw Nix store path (which breaks pnpm install), we copy the source to
  # ~/.understand-anything-plugin at activation time and run pnpm install +
  # tsc build there.  A marker file records which store path was last built
  # so we skip rebuilds when the flake input hasn't changed.
  #
  # Skills are symlinked via activation (not home.file) so they point into
  # the built plugin root rather than the Nix store.  This way Node.js
  # module resolution walks up into the plugin's node_modules/ and finds
  # @understand-anything/core when running .mjs helper scripts.
  uaSrc = inputs.understand-anything;
  uaStorePlugin = "${uaSrc}/understand-anything-plugin";
  uaStoreSkillsDir = "${uaStorePlugin}/skills";
  uaSkillNames = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir uaStoreSkillsDir)
  );

  uaPluginScript = ''
    # --- Understand-Anything plugin setup ---
    export PATH="${pkgs.nodejs}/bin:${pkgs.pnpm}/bin:$PATH"
    UA_SRC="${uaStorePlugin}"
    UA_PLUGIN="$HOME/.understand-anything-plugin"
    UA_MARKER="$UA_PLUGIN/.built-from-store"

    if [ -f "$UA_MARKER" ] \
      && [ "$(cat "$UA_MARKER")" = "$UA_SRC" ] \
      && [ -f "$UA_PLUGIN/packages/core/dist/index.js" ]; then
      echo "[ua] Plugin already built from $UA_SRC, skipping."
      exit 0
    fi

    echo "[ua] Setting up understand-anything plugin..."
    rm -rf "$UA_PLUGIN"
    cp -r "$UA_SRC" "$UA_PLUGIN"
    chmod -R u+w "$UA_PLUGIN"

    echo "[ua] Installing dependencies (pnpm)..."
    (cd "$UA_PLUGIN" && pnpm install --frozen-lockfile) \
      || (cd "$UA_PLUGIN" && pnpm install)

    echo "[ua] Building core (tsc)..."
    (cd "$UA_PLUGIN" && pnpm --filter @understand-anything/core build)

    echo "$UA_SRC" > "$UA_MARKER"
    echo "[ua] Plugin ready at $UA_PLUGIN"
  '';

  uaSkillsScript = ''
    # --- Understand-Anything skills symlinks ---
    UA_PLUGIN="$HOME/.understand-anything-plugin"
    mkdir -p "$HOME/.agents/skills"
    ${lib.concatMapStringsSep "\n" (name: ''
      ln -sfn "$UA_PLUGIN/skills/${name}" "$HOME/.agents/skills/${name}"
    '') uaSkillNames}
    echo "[ua] Skills linked"
  '';
in
{
  home.file = lib.mkMerge (map mpSkillsFor mpCategories);

  home.activation.understandAnythingBuild = lib.hm.dag.entryAfter [ "writeBoundary" ] uaPluginScript;
  home.activation.understandAnythingSkills = lib.hm.dag.entryAfter [ "understandAnythingBuild" ] uaSkillsScript;
}
