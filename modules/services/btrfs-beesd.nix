{ ... }: {
  flake.nixosModules.btrfs-beesd = { pkgs, ... }: {
    services.beesd.filesystems = {
      root = {
        spec = "/dev/mapper/rootfs";
        hashTableSizeMB = 1024;
        workDir = ".beeshome";
        extraOptions = [
          "--loadavg-target"
          "1"
        ];
      };
    };
  };
}
