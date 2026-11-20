{ ... }: {
  flake.homeModules.librewolf = { pkgs, ... }: {
    home.packages = [ pkgs.librewolf-bin ];
  };
}
