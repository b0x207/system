{inputs, ...}: {
  flake.nixosModules.nix-config = {
    pkgs,
    system,
    ...
  }: {
    nix.settings = {
      max-jobs = 2;
      cores = 4;
      auto-optimise-store = true;
      trusted-users = ["ben"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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
      flake = inputs.nixpkgs;
    };

    nixpkgs.hostPlatform = {
      gcc.arch = "arrowlake";
      gcc.tune = "arrowlake";
      system = "x86_64-linux";
    };

    # To prevent long-running nix updates from impacting system responsiveness
    nix.daemonCPUSchedPolicy = "idle";
    nix.daemonIOSchedClass = "idle";

    nixpkgs.config = {
      allowUnfree = true;
    };

    nixpkgs.overlays = [
      inputs.nur.overlays.default
      (import ../overlays/compile-fixes.nix {inherit (inputs) nixpkgs;})
      (import ../overlays/valkey.nix {})
      (import ../overlays/dolphin.nix {})
    ];

    services.nixseparatedebuginfod2.enable = true;

    environment.systemPackages = with pkgs; [
      nix-output-monitor
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 10d --keep 15";
      flake = "/home/ben/config"; # TODO: make better
    };
  };
}
