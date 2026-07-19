{inputs, ...}: {
  flake.nixosModules.nix-config = {
    pkgs,
    system,
    config,
    ...
  }: let
    # TODO: make the handling of host platforms better
    hostArch =
      if config.networking.hostName == "laptop"
      then "arrowlake"
      else "skylake";
  in {
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
        # "gccarch-${hostArch}"
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

    # To prevent long-running nix updates from impacting system responsiveness
    nix.daemonCPUSchedPolicy = "idle";
    nix.daemonIOSchedClass = "idle";

    nixpkgs.config = {
      allowUnfree = true;
    };

    nixpkgs.overlays = [
      inputs.nur.overlays.default
      (import ../overlays/valkey.nix {})
      (import ../overlays/dolphin.nix {})
    ];

    services.nixseparatedebuginfod2.enable = true;

    environment.systemPackages = with pkgs; [
      nix-output-monitor
    ];

    programs.nh = {
      enable = true;
      # clean.enable = true;
      # clean.extraArgs = "--keep-since 10d --keep 15";
      flake = "/home/ben/config"; # TODO: make better
    };
  };
}
