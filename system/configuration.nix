{ config, lib, pkgs, inputs, flake, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  pkgs-intel-compiler = import inputs.nixpkgs-intel-compiler { inherit system; };
  pkgs-modrinth = import inputs.nixpkgs-modrinth { inherit system; config.allowUnfree = true; };
in {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./vpn.nix
    ./fingerprint.nix
    ./firmware.nix
    ./yggdrasil.nix
    ./llm-exploration.nix
    ./virtualbox.nix
  ];

  networking.hostName = "laptop";

  nix.settings = {
    #substituters = [];
    max-jobs = 1;
    cores = 12;
    auto-optimise-store = true;
    trusted-users = [ "ben" ];
    experimental-features = [ "nix-command" "flakes" ];
    ssl-cert-file = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  # To prevent long-running nix updates from impacting system responsiveness
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  nixpkgs.config = {
    allowUnfree = true;
    useCChace = true;
  };

  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.dolphin-overlay.overlays.default

    # Custom packages
    (final: prev: {
    })
  ];

  # Quick patch for compatibility while migrating
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libxcrypt
      libGL
      ocl-icd
      level-zero
      intel-compute-runtime
      stdenv.cc.cc
    ];
  };

  networking = {
    networkmanager = {
      enable = true;
      unmanaged = ["qemu-tap"];
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall = {
      enable = true;
      interfaces.ygg0.allowedTCPPorts = [ 80 443 ];
    };
  };
  systemd.network = {
    netdevs = {
      "qemu-tap" = {
        enable = true;
        netdevConfig = {
          Kind = "tap";
          Name = "qemu-tap";
        };
        tapConfig = {
          User = "ben";
        };
      };
    };
  };

  systemd.sleep.settings.Sleep = {
    AllowHibernation = "no";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  users.users = {
    ben = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "libvirtd" "wireshark" ];
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users.ben = {
      imports = [
        ../user/home-manager.nix
        inputs.catppuccin.homeModules.catppuccin
      ];
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    inputs.neovim-nightly.packages.${system}.default
    ripgrep
    tmux
    rustup
    gh
    modrinth-app
    appimage-run
    python314
    supertuxkart
    librewolf
    docker-compose
    intentrace
    jetbrains.idea
    xonotic
    intel-gpu-tools
    distrobox
    ladybird
    mission-center
    inputs.utpm.packages.${system}.default
    nodejs
    beyond-all-reason
    warzone2100
    thunderbird
    nodejs
    xmake
    pika-backup
    libdrm.dev
    libdrm
    cloudflared
    pkgs-intel-compiler.intel-llvm
    usbutils
    (hunspell.withDicts (dicts: with dicts; [ en-us ]))
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    lmstudio
    alfis
    nix-output-monitor
    nh
    dust
    libnotify
    jellyfin-desktop
    ncurses

    # School
    inputs.typst.packages.${system}.default
    inputs.typst-plantuml.packages.${system}.default
    jetbrains.pycharm
    uv
    sqlitebrowser
    plantuml
    jq
    jdk

    # Desktop environment
    pika-backup
    btop
    ghostty
    quickshell
    swww
    swaynotificationcenter
    rofi-calc
    rofi
    hyprshot
    vimiv-qt
    inputs.hyprshutdown.packages.${system}.default
    dex
    thunar
    kdePackages.dolphin
    satty
    inputs.HyprQuickFrame.packages.${system}.default
    hyprpolkitagent
    kdePackages.breeze-icons
    kdePackages.breeze
    kdePackages.ark
    libreoffice
    wl-clipboard

    # According to the wiki:
    # > By default, dolphin by itself is not packaged with support for SVG icons.
    kdePackages.qtsvg

    # Core system
    zip
    unzip
    man-pages
    man-pages-posix
    clang
    clang-tools
    glibc.dev
    python314
    cacert
    ffmpeg-full
    wget
    git
    gcc
    file
    gnumake
    unixtools.xxd
    blueman
    pavucontrol
  ];

  programs.ccache.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 15";
    flake = "/home/ben/config"; # TODO: make better
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  programs.wireshark = {
    enable = false;
    package = pkgs.wireshark;
    usbmon.enable = true;
  };

  documentation = {
    enable = true;
    dev.enable = true;
    man = {
      enable = true;
      cache.enable = true;
    };
  };

  # Thumbnails
  services.tumbler.enable = true;

  # For building the homelab config
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  systemd.oomd = {
    enable = false;
  };
  services.nohang = {
    enable = true;
    configPath = ./nohang-profile.conf;
  };

  programs.kdeconnect.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };
  programs.xwayland.enable = true;
  security.polkit.enable = true;
  services.seatd.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    roboto
  ];

  # Battery/Power
  services.upower.enable = true;
  services.auto-cpufreq.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  /*services.i2pd = {
    enable = false;
    bandwidth = 1024;
    enableIPv6 = true;
    #ifname = "enp0s31f6";

    proto = {
      socksProxy.enable = true;
      httpProxy.enable = true;
      http.enable = true;
    };
  };*/
  services.i2p.enable = true;

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

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
    grub.enable = true;
    tty.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # btop needs the CAP_PERFMON capability in order to display GPU usage statistics
  security.wrappers.btop = {
    setuid = false;
    source = "${pkgs.btop}/bin/btop";
    owner = "root";
    group = "root";
    capabilities = "CAP_PERFMON=+ep";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
      intel-compute-runtime
      ocl-icd
      level-zero
      intel-npu-driver
      intel-graphics-compiler
      pkgs-intel-compiler.intel-llvm
    ];
  };

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

  system.configurationRevision = toString(flake.rev or flake.dirtyRev or "unknown");

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

