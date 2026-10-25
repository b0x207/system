{ ... }: {
  flake.nixosModules.tailscale = { ... }: {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraSetFlags = [
        "--accept-dns=true"
        "--accept-routes=true"
        "--operator=ben"
      ];
    };

    networking.firewall.trustedInterfaces = [ "tailscale" ];
  };
}
