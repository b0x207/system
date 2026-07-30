{...}: {
  flake.nixosModules.attic = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.attic-client
    ];
  };
}
