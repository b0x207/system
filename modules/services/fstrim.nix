{...}: {
  flake.nixosModules.fstrim = {pkgs, ...}: {
    # Enable periodic trim to help improve SSD lifespan and performance
    services.fstrim.enable = true;
  };
}
