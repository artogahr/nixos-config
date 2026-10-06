{
  # Added next to the unmanaged ~/.ssh/authorized_keys.
  users.users.artogahr.openssh.authorizedKeys.keys = with import ../../../ssh-keys.nix; [ phone ];

  services.openssh = {
    enable = true;
    extraConfig = ''
      SetEnv LANG=en_US.UTF-8
    '';
  };
}
