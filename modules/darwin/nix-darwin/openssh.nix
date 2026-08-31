{
  services.openssh = {
    enable = true;
    extraConfig = ''
      SetEnv LANG=en_US.UTF-8
    '';
  };
}
