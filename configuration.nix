{ config, lib, pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  nix.settings = {
    # substituters = [];
    max-jobs = 1;
    cores = 6;
    auto-optimise-store = true;
    trusted-users = [ "ben" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Quick patch for compatibility while migrating
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
    ];
  };

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  users.users = {
    ben = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    # Programming/General Use
    inputs.neovim-nightly.packages.${system}.default
    tmux
    rustup

    # School
    typst

    # Desktop environment
    fastfetch
    btop
    ghostty
    quickshell
    swww
    swaynotificationcenter
    rofi-calc
    rofi
    hyprshot
    vimiv-qt
    catppuccin-cursors.mochaDark
    catppuccin-gtk
    catppuccin-qt5ct
    catppuccin-grub
    inputs.hyprshutdown.packages.${system}.default

    # Core system
    git
    gnumake
    blueman
    pavucontrol
  ];

  programs.firefox.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.symbols-only
  ];

  # Battery/Power
  services.upower.enable = true;
  services.auto-cpufreq.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Keyboard remapping
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          # capslock = "overload(control, esc)"
          capslock = "esc";
          esc = "capslock";
          leftalt = "layer(extension)";
        };
        extension = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };
      };
    };
  };

  # btop needs the CAP_PERFMON capability in order to display GPU usage statistics
  security.wrappers.btop = {
    setuid = false;
    source = "${pkgs.btop}/bin/btop";
    owner = "root";
    group = "root";
    capabilities = "CAP_PERFMON=+ep";
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      configurationLimit = 5;
      extraEntries = ''
        menuentry "Windows Boot Manager" --class windows --id windows {
          insmod part_gpt
            insmod fat
            search --no-floppy --fs-uuid --set=root 924F-952F
            chainloader ($\{root})/EFI/Microsoft/Boot/bootmgfw.efi
        }

        # Gentoo Holdover

        menuentry 'Gentoo GNU/Linux' --class gentoo --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-abb2f538-2ec5-4fa9-b168-811574181bff' {
          load_video
            insmod gzio
            insmod part_gpt
            insmod fat
            search --no-floppy --fs-uuid --set=root B99A-F204
            echo	'Loading Linux 6.12.63-gentoo-dist ...'
            linux	/kernel-6.12.63-gentoo-dist root=UUID=abb2f538-2ec5-4fa9-b168-811574181bff ro rootflags=subvol=@gentoo  
            echo	'Loading initial ramdisk ...'
            initrd	/intel-ucode.img /initramfs-6.12.63-gentoo-dist.img
        }
      submenu 'Advanced options for Gentoo GNU/Linux' $menuentry_id_option 'gnulinux-advanced-abb2f538-2ec5-4fa9-b168-811574181bff' {
        menuentry 'Gentoo GNU/Linux, with Linux 6.12.63-gentoo-dist' --class gentoo --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-6.12.63-gentoo-dist-advanced-abb2f538-2ec5-4fa9-b168-811574181bff' {
          load_video
            insmod gzio
            insmod part_gpt
            insmod fat
            search --no-floppy --fs-uuid --set=root B99A-F204
            echo	'Loading Linux 6.12.63-gentoo-dist ...'
            linux	/kernel-6.12.63-gentoo-dist root=UUID=abb2f538-2ec5-4fa9-b168-811574181bff ro rootflags=subvol=@gentoo  
            echo	'Loading initial ramdisk ...'
            initrd	/intel-ucode.img /initramfs-6.12.63-gentoo-dist.img
        }
        menuentry 'Gentoo GNU/Linux, with Linux 6.12.63-gentoo-dist (recovery mode)' --class gentoo --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-6.12.63-gentoo-dist-recovery-abb2f538-2ec5-4fa9-b168-811574181bff' {
          load_video
            insmod gzio
            insmod part_gpt
            insmod fat
            search --no-floppy --fs-uuid --set=root B99A-F204
            echo	'Loading Linux 6.12.63-gentoo-dist ...'
            linux	/kernel-6.12.63-gentoo-dist root=UUID=abb2f538-2ec5-4fa9-b168-811574181bff ro single rootflags=subvol=@gentoo 
            echo	'Loading initial ramdisk ...'
            initrd	/intel-ucode.img /initramfs-6.12.63-gentoo-dist.img
        }
      }
      '';
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

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
}

