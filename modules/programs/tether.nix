{ inputs, ... }: {
  flake.nixosModules.tether = { pkgs, ... }: {
    programs.tether = {
      enable = true;
      package = inputs.tether.packages.${pkgs.stdenv.system}.tether;

      wifi = {
        enable = false;
      };

      bluetooth = {
        enable = true;
      };
    };
  };
}
