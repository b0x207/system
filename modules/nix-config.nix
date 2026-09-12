{ inputs, ... }: {
  flake.nixosModules.nix-config =
    {
      pkgs,
      config,
      ...
    }:
    let
      # TODO: make the handling of host platforms better
      hostArch = if config.networking.hostName == "laptop" then "arrowlake" else "skylake";
    in
    {
      nix.settings = {
        # TODO: make automatic lockstep with CPU affinity
        max-jobs = 2;
        cores = if hostArch == "arrowlake" then 3 else 4;

        auto-optimise-store = true;
        trusted-users = [ "ben" ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        ssl-cert-file = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

        # substituters = [
        #   "https://nix-cache.b0x207.dev/b0x207"
        # ];
        # trusted-public-keys = [
        #   "b0x207:oWb7Z73tEXZyk7NrvAmj3RLabX7APnup4p+CHE1dDC4="
        # ];

        # Attempt to enable more optimizations
        system-features = [
          # Present by default
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"

          # Custom
          "gccarch-${hostArch}"
        ];
      };

      # nixpkgs.hostPlatform = {
      #   system = "x86_64-linux";
      #   gcc.arch = hostArch;
      #   gcc.tune = hostArch;
      # };

      # I already run nix builds with a limited number of jobs. Instead, let's just for a CPU
      # affinity for p-cores only
      systemd.services.nix-daemon.serviceConfig = {
        # If not arrowlake, then this system must be a skylake or coffee lake CPU which both
        # predate Intel's switch to a heterogeneous core architecture. Thus, we'll just allocate 8
        # cores as a sensible default.
        CPUAffinity = if hostArch == "arrowlake" then "0-5" else "0-7";
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
        # inputs.hyprland.overlays.hyprland-packages
        # inputs.hyprland.overlays.hyprland-extras
        (import ../overlays/valkey.nix { })
        (import ../overlays/dolphin.nix { })
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
