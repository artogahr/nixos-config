# Apify CLI on Linux; not in nixpkgs (the Mac gets it from Homebrew). Uses the upstream standalone
# binary. It's a Bun-compiled executable, which patchelf would corrupt, so it stays unpatched and
# runs through nix-ld (enabled in modules/linux/nixos/base.nix).
# Update: bump `version`, then `nix store prefetch-file <url>` for the new hash.
{ pkgs, ... }:
let
  version = "1.10.0";
  apify-cli = pkgs.stdenvNoCC.mkDerivation {
    pname = "apify-cli";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/apify/apify-cli/releases/download/v${version}/apify-${version}-linux-x64";
      hash = "sha256-fNl3cgQdtFKeZGE7UXPre3GzTx9d4weXWDAtX0GELB8=";
    };
    dontUnpack = true;
    dontPatchELF = true;
    dontStrip = true;
    installPhase = ''
      install -Dm755 $src $out/bin/apify
    '';
    meta.platforms = [ "x86_64-linux" ];
  };
in
{
  home.packages = [ apify-cli ];
}
