{ ... }: {
  flake.homeModules.tor-browser = { pkgs, ... }: {
    home.packages = [ pkgs.tor-browser ];
  };
}
