{ ... }: {
  flake.nixosModules.thermald = { ... }: {
    services.thermald = {
      enable = true;
      configFile = ./config.xml;
    };
  };
}
