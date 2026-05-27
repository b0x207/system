{ config, lib, pkgs, inputs, flake, system, patched-nixpkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./vpn.nix
    ./fingerprint.nix
    ./firmware.nix
    # ./yggdrasil.nix
    ./llm-exploration.nix
    ./virtualbox.nix
    ./i2p.nix
    ./file-manager.nix
    ./email.nix
    ./jellyfin.nix
    ./stylix.nix

    ../modules/theme/system.nix
  ];

  networking.hostName = "laptop";

  nix.settings = {
    # substituters = [];
    max-jobs = 2;
    cores = 4;
    auto-optimise-store = true;
    trusted-users = [ "ben" ];
    experimental-features = [ "nix-command" "flakes" ];
    ssl-cert-file = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

    # Attempt to enable more optimizations
    system-features = [
      # Present by default
      "nixos-test"
      "benchmark"
      "big-parallel"
      "kvm"

      # Custom
      "gccarch-arrowlake"
    ];
  };

  nix.registry.nixpkgs = {
    exact = true;
    from = {
      type = "indirect";
      id = "nixpkgs";
    };
    flake = patched-nixpkgs;
  };

  nixpkgs.hostPlatform = {
    # gcc.arch = "arrowlake";
    # gcc.tune = "arrowlake";
    inherit system;
  };

  # To prevent long-running nix updates from impacting system responsiveness
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    inputs.nur.overlays.default
    (import ./overlays/compile-fixes.nix { inherit (inputs) nixpkgs; })
    (import ./overlays/valkey.nix {})
    (import ./overlays/dolphin.nix {})
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

      # For Minecraft
      libxrender
      libxtst
      libxi
      vulkan-loader
      libglvnd
    ];
  };

  networking = {
    networkmanager = {
      enable = true;
      unmanaged = ["qemu-tap"];
    };
    nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    firewall = {
      enable = true;
      interfaces.ygg0.allowedTCPPorts = [ 80 443 ];
    };
  };
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = true;
      # DNSSEC = true;  # too many verification problems
      DNS = [ "1.1.1.1" "8.8.8.8" ];
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
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  systemd.sleep.settings.Sleep = {
    # Hibernation can cause weird problems with no physical swap device
    AllowHibernation = "no";
  };

  time.timeZone = "America/Los_Angeles";

  services.timesyncd = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" ];
  };

  users.users = {
    ben = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" "libvirtd" "wireshark" "render" "video" ];
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
    level-zero
    intel-compute-runtime
    intel-gpu-tools

    kdiskmark
    neovim
    ripgrep
    tmux
    rustup
    gh
    modrinth-app
    tor-browser
    appimage-run
    python314
    supertuxkart
    librewolf
    intentrace
    xonotic
    intel-gpu-tools
    distrobox
    # ladybird
    mission-center
    inputs.utpm.packages.${system}.default
    nodejs
    beyond-all-reason
    warzone2100
    nodejs
    xmake
    pika-backup
    libdrm.dev
    libdrm
    cloudflared
    intel-llvm
    usbutils
    (hunspell.withDicts (dicts: with dicts; [ en-us ]))
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    lmstudio
    nix-output-monitor
    nh
    dust
    qalculate-qt
    libqalculate
    fend
    libnotify
    jellyfin-desktop
    ncurses
    biglybt
    jdk21 # for minecraft
    glib
    supertux
    inputs.todo-tree.packages.${pkgs.stdenv.hostPlatform.system}.todo-tree
    tree-sitter
    krita
    obs-studio

    # Dumb GPG bullshit
    gnupg
    pinentry-tty

    # School
    inputs.typst.packages.${system}.default
    inputs.typst-plantuml.packages.${system}.default
    uv
    sqlitebrowser
    plantuml
    jq
    jdk
    (mars-mips.overrideAttrs {
      jre = javaPackages.compiler.openjdk11;
    })

    # Desktop environment
    pika-backup
    btop
    ghostty
    quickshell
    awww
    swaynotificationcenter
    rofi-calc
    rofi
    hyprshot
    vimiv-qt
    mpv
    hyprshutdown
    dex
    satty
    inputs.HyprQuickFrame.packages.${system}.default
    hyprpolkitagent
    kdePackages.breeze-icons
    kdePackages.breeze
    kdePackages.ark
    libreoffice
    wl-clipboard
    brightnessctl
    kdePackages.breeze

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
    bluejay
    kdePackages.bluedevil
    pavucontrol
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 15";
    flake = "/home/ben/config"; # TODO: make better
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    languagePacks = [ "en-US" ];
  };

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  documentation = {
    enable = true;
    dev.enable = true;
    man = {
      enable = true;
      cache.enable = true;
    };
  };

  # For building the homelab config
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  systemd.oomd = {
    enable = false;
  };
  services.nohang = {
    enable = true;
    configPath = ./nohang-profile.conf;
  };

  services.nixseparatedebuginfod2.enable = true;

  programs.kdeconnect.enable = true;

  programs.hyprland = {
    enable = true;
    # withUWSM = true;
  };
  programs.xwayland.enable = true;
  security.polkit.enable = true;
  services.seatd.enable = true;

  xdg.portal = {
    enable = true;
    configPackages = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [ "hyprland" "kde" ];
        "org.freedesktop.impl.portal.FileChooser" = "kde";
      };

      hyprland = {
        default = [
          "hyprland"
          "kde"
        ];
      };
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    roboto
    dejavu_fonts
  ];
  
  services.karakeep = {
    enable = false;
    extraEnvironment = {
      OPENAI_BASE_URL = "http://127.0.0.1:1234/v1";
      DISABLE_SIGNUPS = "true";
      DISABLE_NEW_RELEASE_CHECK = "true";
      PORT = "5353";
      OPENAI_API_KEY = "lm_studio";
      INFERENCE_IMAGE_MODEL = "smollm3-3b";
      EMBEDDING_TEXT_MODEL = "gemma3-4b";
    };
  };

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

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.containerd.enable = true;

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
      intel-llvm
    ];
  };

  # Enable periodic trim to help improve SSD lifespan and performance
  services.fstrim.enable = true;

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

