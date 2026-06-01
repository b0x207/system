{...}: {
  flake.nixosModules.i2p = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      biglybt
    ];

    services.i2pd = {
      enable = true;
      bandwidth = 1024;
      enableIPv6 = true;

      proto = {
        socksProxy.enable = true;
        httpProxy.enable = true;
        http.enable = true;
        i2cp.enable = true;
      };

      inTunnels.webhost = {
        enable = true;
        keys = "webhost-keys.dat";
        port = 26000;
        name = "127.0.0.1";
        address = "127.0.0.1";
        type = "udpserver";
      };
    };

    # An attempt to see how eepsites work
    services.httpd = {
      enable = false;
      enablePHP = true;
      virtualHosts.eepsite = {
        listen = [
          {
            ip = "127.0.0.1";
            port = 9191;
          }
        ];
        locations."/" = {
          index = "index.php index.html";
        };
        servedDirs = [
          {
            dir = "/var/www";
            urlPath = "/";
          }
        ];
      };
    };

    # Still trying to figure out how to get UDP for Xonotic to go over i2p
    programs.proxychains = {
      enable = false;
      package = pkgs.proxychains-ng;
      proxies.i2p = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 4447;
      };
    };
  };
}
