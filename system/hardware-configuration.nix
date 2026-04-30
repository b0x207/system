{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.systemd.enable = true;
  boot.kernelModules = [ "kvm-intel" "usbmon" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;
  boot.kernel.sysctl."vm.swappiness" = 5;
  boot.kernelParams = [
    "pcie_aspm=off"
    "nvme_core.default_ps_max_latency_us=0"
  ];
  # boot.kernelParams = [
  #   "zswap.enabled=1"
  #   "zswap.compressor=lz4"
  #   "zswap.max_pool_percent=20"
  #   "zswap.shrinker_enabled=1"
  # ];
  # boot.blacklistedKernelModules = [ "i915" ];
  # boot.kernelParams = [
  #   "i915.force_probe=!"
  #   "xe.force_probe=*"
  # ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/abb2f538-2ec5-4fa9-b168-811574181bff";
      fsType = "btrfs";
      options = [ "subvol=@linux" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/abb2f538-2ec5-4fa9-b168-811574181bff";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=@nix" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/abb2f538-2ec5-4fa9-b168-811574181bff";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B99A-F204";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [{
    device = "/dev/disk/by-partuuid/17ad8cfd-74dc-46e1-90ad-13d2dfc733c8";
    randomEncryption.enable = true;
    priority = 0;
  }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
