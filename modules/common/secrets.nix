# Secrets live sops-encrypted in the private artogahr/nix-secrets repo (the `nix-secrets` flake
# input). Each host decrypts them with its own age key at ~/.config/sops/age/keys.txt.
{ config, inputs, ... }:
let
  # Exported to interactive fish shells so agents started from them can use them.
  envSecrets = {
    REDASH_API_KEY = "redash-api-key";
    HOMEASSISTANT_TOKEN = "homeassistant-token";
    MEZMO_API_KEY = "mezmo-api-key";
    LANGFUSE_AUTH = "langfuse-auth";
  };
in
{
  sops = {
    defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      apify-token = { };
    }
    // builtins.listToAttrs (
      map (name: {
        inherit name;
        value = { };
      }) (builtins.attrValues envSecrets)
    );
  };

  # Read each decrypted file directly, so no secret value is ever quoted into a script.
  programs.fish.interactiveShellInit = builtins.concatStringsSep "\n" (
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
