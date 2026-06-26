{...}: {
  flake.nixosModules.i2p = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      biglybt
    ];

    services.i2p.enable = true;

    networking.firewall.allowedUDPPorts = [ 123 ];

    # services.i2pd = {
    #   enable = true;
    #   bandwidth = 1024;
    #   enableIPv6 = true;
    #
    #   proto = {
    #     socksProxy.enable = true;
    #     httpProxy.enable = true;
    #     http.enable = true;
    #     i2cp.enable = true;
    #   };
    #
    #   inTunnels.webhost = {
    #     enable = true;
    #     keys = "webhost-keys.dat";
    #     port = 26000;
    #     name = "127.0.0.1";
    #     address = "127.0.0.1";
    #     type = "udpserver";
    #   };
    # };
  };
}
