{...}: {
  flake.nixosModules.btop = {
    config,
    pkgs,
    ...
  }: {
    # btop needs the CAP_PERFMON capability in order to display GPU usage statistics
    security.wrappers.btop = let
      btop-pkg =
        if config.networking.hostName == "desktop"
        then pkgs.btop-cuda
        else pkgs.btop;
    in {
      setuid = false;
      source = "${btop-pkg}/bin/btop";
      owner = "root";
      group = "root";
      capabilities = "CAP_PERFMON=+ep";
    };
  };

  flake.homeModules.btop = {
    osConfig,
    pkgs,
    ...
  }: {
    programs.btop = {
      enable = true;
      package =
        if osConfig.networking.hostName == "desktop"
        then pkgs.btop-cuda
        else pkgs.btop;
      settings = {
        disks_filter = "/boot /";
      };
    };
  };
}
