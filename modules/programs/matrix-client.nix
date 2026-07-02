{...}: {
  flake.nixosModules.matrix-client = {pkgs, ...}: {
    environment.systemPackages = [pkgs.fluffychat];
  };
}
