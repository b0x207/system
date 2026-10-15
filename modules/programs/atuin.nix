{ ... }: {
  flake.homeModules.atuin = { ... }: {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
    };
  };
}
