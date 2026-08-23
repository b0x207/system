{...}: {
  flake.nixosModules.uci-vpn = {pkgs, ...}: {
    networking.networkmanager.plugins = with pkgs; [
      networkmanager-openconnect
    ];

    networking.networkmanager.ensureProfiles.profiles.uci-vpn = {
      connection = {
        id = "UciVpn";
        type = "vpn";
      };
      vpn = rec {
        gateway = "vpn.uci.edu";
        remote = gateway;
        service-type = "org.freedesktop.NetworkManager.openconnect";
        protocol = "anyconnect";
        useragent = "AnyConnect";
        csd_wrapper = "${pkgs.openconnect}/libexec/openconnect/csd-post.sh";
        enable_csd_trojan = "yes";
        # authgroup = "UCI
      };
    };
  };
}
