{ ... }: {
  flake.homeModules.kopuz = { pkgs, ... }: {
    home.packages = [ pkgs.kopuz ];
  };
}
