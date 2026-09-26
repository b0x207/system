{ ... }: {
  flake.nixosModules.networking = { ... }: {
    networking = {
      networkmanager = {
        enable = true;
      };
      firewall = {
        enable = true;
        interfaces.ygg0.allowedTCPPorts = [
          80
          443
        ];
      };

      hosts = {
        "127.0.0.1" = [ "localhost" ];

        # To ensure that core services are functional even on networks without IPv6 (SHAME THEM!)
        "100.109.87.89" = [ "git.b0x207.dev" ];
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}
