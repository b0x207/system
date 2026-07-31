{...}: {
  flake.nixosModules.tailscale = {pkgs, ...}: {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--accept-dns=false" "--operator=ben" ];
    };

    networking.firewall.trustedInterfaces = ["tailscale"];
  };
}
