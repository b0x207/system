{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktop-hw
      self.nixosModules.desktop-config

      inputs.home-manager.nixosModules.home-manager
      #
      # self.nixosModules.jellyfin
      self.nixosModules.i2p
      # self.nixosModules.lm-studio
      # self.nixosModules.local-ai
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

      self.nixosModules.user
      self.nixosModules.catppuccin
      # self.nixosModules.fstrim
      self.nixosModules.keyd
      self.nixosModules.bluetooth
      self.nixosModules.audio
      self.nixosModules.intel-igpu
      self.nixosModules.nvidia-gpu
      self.nixosModules.nohang-oomd
      # self.nixosModules.btrfs-beesd
      self.nixosModules.core-system
      self.nixosModules.tz-and-locale
      self.nixosModules.nix-ld
      self.nixosModules.networking
      self.nixosModules.nix-config
      self.nixosModules.firmware
    ];
  };

  flake.nixosModules.desktop-config = {pkgs, ...}: {
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      limine = {
        enable = true;
        efiInstallAsRemovable = true;
      };
    };

    networking.hostName = "desktop";

    system.configurationRevision = toString (self.rev or self.dirtyRev or "unknown");

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

  flake.nixosModules.desktop-hw = {
    config,
    pkgs,
    lib,
    ...
  }: {
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [];
    boot.initrd.systemd.enable = true;
    boot.kernelModules = [
      "kvm-intel"
    ];
    boot.extraModulePackages = [];
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.enableRedistributableFirmware = true;
    boot.kernel.sysctl."vm.swappiness" = 5;

    systemd.sleep.settings.Sleep = {
      # Hibernation can't work when using an encrypted swap
      AllowHibernation = "no";
    };

    fileSystems."/" = {
      device = "/dev/mapper/rootfs";
      fsType = "btrfs";
      options = ["subvol=@root" "noatime" "compress=zstd"];
    };

    boot.initrd.luks.devices."rootfs".device = "/dev/disk/by-uuid/9606c000-3a33-4e50-81ee-db61ad4acabe";

    fileSystems."/nix" = {
      device = "/dev/mapper/rootfs";
      fsType = "btrfs";
      options = ["subvol=@nix" "noatime" "compress=zstd"];
    };

    fileSystems."/home" = {
      device = "/dev/mapper/rootfs";
      fsType = "btrfs";
      options = ["subvol=@home" "noatime" "compress=zstd"];
    };

    fileSystems."/var/log" = {
      device = "/dev/mapper/rootfs";
      fsType = "btrfs";
      options = ["subvol=@log" "noatime" "compress=zstd"];
      neededForBoot = true;
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/8379-2604";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    swapDevices = [
      {
        device = "/dev/disk/by-partuuid/481c8904-1794-4588-ab02-feb7c8a64aa0";
        randomEncryption = {
          enable = true;
          allowDiscards = true;
        };
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
