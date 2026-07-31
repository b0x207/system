{...}: {
  flake.nixosModules.networking = {...}: {
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
