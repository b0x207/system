{ ... }: {
  flake.homeModules.cargo = { ... }: {
    programs.cargo = {
      enable = true;
      cargoHome = "${config.xdg.dataHome}/cargo";
    };
  };
}
