{ ... }: {
  flake.homeModules.discord = { ... }: {
    programs.discord = {
      enable = true;
      settings.SKIP_HOST_UPDATE = true;
    };
  };
}
