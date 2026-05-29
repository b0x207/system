{
  config,
  pkgs,
  ...
}: let
  csd-wrapper-cisco = pkgs.fetchurl {
    url = "https://gitlab.com/openconnect/openconnect/-/raw/master/trojans/csd-wrapper.sh";
    hash = "sha256-N4TkFiETrEYu2LvhxvaKRMg5W3mlJKJFNi3ln1+vTJM=";
  };
in {
  imports = [./secrets.nix];

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanager-openconnect
    networkmanagerapplet
  ];

  # UCI VPN
  # networking.openconnect = {
  #   interfaces.openconnect0 = {
  #     gateway = "vpn.uci.edu";
  #     protocol = "anyconnect";
  #     passwordFile = config.age.secrets.openconnect.path;
  #     autoStart = true;
  #     extraOptions = {
  #       csd-wrapper = toString csd-wrapper-cisco;
  #     };
  #   };
  # };
}
