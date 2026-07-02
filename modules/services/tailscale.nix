{...}: {
  flake.nixosModules.tailscale = {pkgs, ...}: {
    services.tailscale.enable = true;

    networking.firewall.trustedInterfaces = ["tailscale"];
  };
}
