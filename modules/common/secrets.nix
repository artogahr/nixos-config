# Secrets live sops-encrypted in the private artogahr/nix-secrets repo (the `nix-secrets` flake
# input). Each host decrypts them with its own age key at ~/.config/sops/age/keys.txt.
{ config, inputs, ... }:
let
  # Exported to every fish shell so agents started from one can use them.
  envSecrets = {
    REDASH_API_KEY = "redash-api-key";
    HOMEASSISTANT_TOKEN = "homeassistant-token";
    MEZMO_API_KEY = "mezmo-api-key";
    LANGFUSE_AUTH = "langfuse-auth";
    APIFY_TOKEN = "apify-token";
  };
in
{
  sops = {
    defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      apify-token = { };
      artomatic-apify-token = { };
      artomatic-apify-proxy-password = { };
      artomatic-slack-bot-token = { };
      artomatic-slack-app-token = { };
      homebrew-github-api-token = { };
    }
    // builtins.listToAttrs (
      map (name: {
        inherit name;
        value = { };
      }) (builtins.attrValues envSecrets)
    );
    templates."homebrew-brew.env" = {
      content = "HOMEBREW_GITHUB_API_TOKEN=${config.sops.placeholder.homebrew-github-api-token}\n";
      path = "${config.home.homeDirectory}/.homebrew/brew.env";
    };
  };

  home.sessionVariables.SOPS_AGE_KEY_FILE = config.sops.age.keyFile;

  # Read each decrypted file directly, so no secret value is ever quoted into a script.
  programs.fish.shellInit = builtins.concatStringsSep "\n" (
    builtins.attrValues (
      builtins.mapAttrs (
        var: secret:
        let
          path = config.sops.secrets.${secret}.path;
        in
        "test -r ${path}; and set -gx ${var} (string collect < ${path})"
      ) envSecrets
    )
  );
}
