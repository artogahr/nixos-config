# Language runtimes for projects that expect them on the machine (the Mac has its own outside nix).
# Node 24 matches the apify/actor-node:24 images the Apify repos build on.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_24
    python3
  ];
}
