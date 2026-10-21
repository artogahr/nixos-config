# CodexBar plugins. The app comes from the Homebrew cask (modules/darwin/nix-darwin/homebrew.nix).
{ lib, ... }:
{
  # CodexBar rejects a plugin that is a symlink ("plugin path is not a regular file"), so the
  # file is copied instead of linked with home.file.
  home.activation.codexbarPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run install -Dm644 ${./codexbar/apify-openrouter.js} "$HOME/.config/codexbar/providers/apify-openrouter.js"
  '';
}
