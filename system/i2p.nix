{ pkgs, ... }:
{
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

  services.httpd = {
    enable = false;
    enablePHP = true;
    virtualHosts.eepsite = {
      listen = [ {
        ip = "127.0.0.1";
        port = 9191;
      } ];
      locations."/" = {
        index = "index.php index.html";
      };
      servedDirs = [ {
        dir = "/var/www";
        urlPath = "/";
      } ];
    };
  };

  services.xonotic = {
    enable = true;
    openFirewall = true;
    settings = {
      hostname = "Ben's Xonotic $g_xonoticversion Server";
      sv_motd = "This is a test server";
      gametype = "ft";
      fraglimit = 0;
      timelimit = 0;
      leadlimit = 30; # You must thoroughly win
      rcon_password = "foo";
      # g_maplist = "implosion";

      # Make bots have their own team
      # g_balance_teams = 0;
      # g_balance_teams_prevent_unbalanced = 0;
      # g_maxplayers = 0;
      # bot_number = 20;
      # g_ca_teams = 4;
      g_nix = 1;
      # bot_vs_human = -1; # Negative for blue humans
    };
  };

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
}
