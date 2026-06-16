{...}: {
  flake.nixosModules.networking = {...}: {
    networking = {
      networkmanager = {
        enable = true;
        unmanaged = ["qemu-tap"];
      };
      nameservers = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      firewall = {
        enable = true;
        interfaces.ygg0.allowedTCPPorts = [
          80
          443
        ];
      };
    };
    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = true;
        # DNSSEC = true;  # too many verification problems
        DNS = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
    systemd.network = {
      netdevs = {
        "qemu-tap" = {
          enable = true;
          netdevConfig = {
            Kind = "tap";
            Name = "qemu-tap";
          };
          tapConfig = {
            User = "ben";
          };
        };
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
