{ ... }: {
  flake.nixosModules.kernel = { pkgs, ... }: {
    # Gotta have the latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    console = {
      # Enable VT switching
      enable = true;

      colors = [ ];
    };
  };
}
