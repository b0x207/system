{
  config,
  pkgs,
  lib,
  ...
}: let
  listen_port = 4167;
in {
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    settings = {
      Listen = [
        "tcp://[::]:${toString listen_port}"
        "tls://[::]:${toString listen_port}"
        "quic://[::]:${toString listen_port}"
      ];
      Peers = [
        "tls://ygg.jjolly.dev:3443"
        "tls://[2602:fc24:18:7a42::1]:993"
        "quic://mo.us.ygg.triplebit.org:443"
      ];
      IfName = "ygg0";
    };
  };

  services.yggdrasil-jumper = {
    enable = true;
  };

  /*
  systemd.services.yggstack = {
    enable = false;
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Yggdrasil as SOCKS proxy / port forwarder";
    serviceConfig = let
      yggstack = "${pkgs.yggstack}/bin/yggstack";

      # We need access the path to yggdrasil's config
      # to get this, we will abuse the nature of how the systemd service config is written
      yggdrasil-config = builtins.elemAt (lib.strings.splitString " " config.systemd.services.yggdrasil.script) 3;
    in {
      ExecStart = "${yggstack} -useconf ${yggdrasil-config} -socks 127.0.0.1:1080";
    };
  };
  */
}
