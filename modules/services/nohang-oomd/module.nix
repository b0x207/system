{...}: {
  flake.nixosModules.nohang-oomd = {...}: {
    systemd.oomd = {
      enable = false;
    };
    services.nohang = {
      enable = true;
      configPath = ./nohang-profile.conf;
    };
  };
}
