{ ... }: {
  flake.nixosModules.tailscale = { pkgs, ... }: {
    services.tailscale = {
      enable = true;
      extraSetFlags = [
        "--accept-dns=true"
        "--operator=ben"
      ];
    };

    networking.firewall.trustedInterfaces = [ "tailscale" ];
  };

  flake.modules.darwin.tailscale = { ... }: {
    services.tailscale = {
      enable = true;
    };
  };
}
