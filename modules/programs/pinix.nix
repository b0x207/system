{inputs, ...}: {
  flake.nixosModules.pinix = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.pinix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
