{...}: {
  flake.nixosModules.networking = {...}: {
    networking = {
      networkmanager.enable = true;
      resolvconf.enable = true;
      nameservers = [
        "127.0.0.1"
      ];
      firewall = {
        enable = true;
        interfaces.ygg0.allowedTCPPorts = [
          80
          443
        ];
      };
    };

    # environment.etc."resolv.conf".text = ''
    #   nameserver 127.0.0.1
    # '';

    services.resolved.enable = false;
    services.dnsmasq = {
      enable = true;

      settings = {
        no-resolv = true;
        server = [
          "100.109.87.89"
          "1.1.1.1"
        ];
      };
    };

    networking.extraHosts = ''
      100.109.87.89 faesten
    '';

    # For MDNS
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
