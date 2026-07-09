{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptop-hw
      self.nixosModules.laptop-config

      inputs.home-manager.nixosModules.home-manager

      # Disable till secrets are needed
      # inputs.agenix.nixosModules.default

      self.nixosModules.jellyfin
      self.nixosModules.i2p
      self.nixosModules.lm-studio
      self.nixosModules.local-ai
      self.nixosModules.games
      self.nixosModules.xonotic
      self.nixosModules.typst
      self.nixosModules.tmux
      self.nixosModules.neovim
      self.nixosModules.tailscale
      self.nixosModules.libreoffice
      self.nixosModules.appimage
      self.nixosModules.dev-tools
      self.nixosModules.pika-backup
      self.nixosModules.multimedia-tools
      self.nixosModules.homelab
      self.nixosModules.kdeconnect
      self.nixosModules.iphone
      self.nixosModules.disk-tools
      self.nixosModules.matrix-client

      self.nixosModules.hyprland
      self.nixosModules.theme
      self.nixosModules.dictionary
      self.nixosModules.email
      self.nixosModules.file-manager
      self.nixosModules.browser
      self.nixosModules.calculator
      self.nixosModules.fonts
      self.nixosModules.btop
      self.nixosModules.gpg
      self.nixosModules.ghostty
      self.nixosModules.quickshell
      self.nixosModules.awww
      self.nixosModules.sway-notification-center
      self.nixosModules.hyprquickframe
      self.nixosModules.clipboard

      self.nixosModules.scanner
      self.nixosModules.user
      self.nixosModules.catppuccin
      self.nixosModules.fstrim
      self.nixosModules.keyd
      self.nixosModules.battery
      self.nixosModules.bluetooth
      self.nixosModules.audio
      self.nixosModules.intel-igpu
      self.nixosModules.nohang-oomd
      self.nixosModules.btrfs-beesd
      self.nixosModules.core-system
      self.nixosModules.tz-and-locale
      self.nixosModules.nix-ld
      self.nixosModules.networking
      self.nixosModules.nix-config
      self.nixosModules.firmware
    ];
  };

  flake.nixosModules.laptop-config = {pkgs, ...}: {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 5;
      };
    };

    networking.hostName = "laptop";

    system.configurationRevision = toString (self.rev or self.dirtyRev or "unknown");

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "25.11"; # Did you read the comment?
  };

  flake.nixosModules.laptop-hw = {
    config,
    pkgs,
    lib,
    ...
  }: {
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "vmd"
      "nvme"
      "usbhid"
      "rtsx_pci_sdmmc"
    ];
    boot.initrd.kernelModules = [];
    boot.initrd.systemd.enable = true;
    boot.kernelModules = [
      "kvm-intel"
      "usbmon"
    ];
    boot.extraModulePackages = [];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.enableRedistributableFirmware = true;
    boot.kernel.sysctl."vm.swappiness" = 5;
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

    systemd.sleep.settings.Sleep = {
      # Hibernation can cause weird problems with no physical swap device
      AllowHibernation = "no";
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/abb2f538-2ec5-4fa9-b168-811574181bff";
      fsType = "btrfs";
      options = [
        "subvol=@linux"
        # "compress=zstd"
      ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-uuid/abb2f538-2ec5-4fa9-b168-811574181bff";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "subvol=@nix"
        "noatime"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/abb2f538-2ec5-4fa9-b168-811574181bff";
      fsType = "btrfs";
      options = ["subvol=@home"];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/B99A-F204";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [
      {
        device = "/dev/disk/by-partuuid/17ad8cfd-74dc-46e1-90ad-13d2dfc733c8";
        randomEncryption.enable = true;
        priority = 0;
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
