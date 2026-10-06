{ ... }:

{
  # Sign through 1Password's SSH agent, but only where git-work.nix turns signing on
  # (~/workplace/apify), so personal repos never trigger a 1Password prompt.
  programs.git.settings."gpg \"ssh\"".program =
    "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
