{ inputs, ... }: {
  flake.homeModules.kopuz = { pkgs, ... }: {
    home.packages = [ inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
