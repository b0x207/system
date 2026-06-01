{inputs, ...}: {
  flake.nixosModules.typst = {pkgs, ...}: {
    environment.systemPackages = [
      inputs.typst.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.typst-plantuml.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.utpm.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
