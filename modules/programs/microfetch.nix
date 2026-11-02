{ ... }: {
  flake.homeModules.microfetch = { pkgs, ... }: {
    home.packages = [ pkgs.microfetch ];
  };
}
