{
  # Galaxy S24, herdroid app. Added next to the unmanaged ~/.ssh/authorized_keys.
  users.users.artogahr.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIACH2OlGYvVK5PmhJa/C55c0BqpOLNbVVZ+veZqlo1Qi herdroid@SM-S921B"
  ];

  services.openssh = {
    enable = true;
    extraConfig = ''
      SetEnv LANG=en_US.UTF-8
    '';
  };
}
