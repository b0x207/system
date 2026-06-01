{...}: {
  flake.nixosModules.btop = {pkgs, ...}: {
    # btop needs the CAP_PERFMON capability in order to display GPU usage statistics
    security.wrappers.btop = {
      setuid = false;
      source = "${pkgs.btop}/bin/btop";
      owner = "root";
      group = "root";
      capabilities = "CAP_PERFMON=+ep";
    };
  };

  flake.homeManagerModules.btop = {pkgs, ...}: {
    programs.btop = {
      enable = true;
      settings = {
        disks_filter = "/boot /";
      };
    };
  };
}
