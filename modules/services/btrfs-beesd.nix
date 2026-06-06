{...}: {
  flake.nixosModules.btrfs-beesd = {pkgs, ...}: {
    services.beesd.filesystems = {
      root = {
        spec = "/dev/disk/by-uuid/abb2f538-2ec5-4fa9-b168-811574181bff";
        hashTableSizeMB = 1024;
        workDir = ".beeshome";
        extraOptions = [
          "--loadavg-target"
          "8"
        ];
      };
    };
  };
}
