{ ... }: {
  flake.homeModules.nix-output-monitor = { pkgs, ... }: {
    home.packages = [ pkgs.nix-output-monitor ];
  };
}
