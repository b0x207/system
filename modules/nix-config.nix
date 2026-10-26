{ self, inputs, ... }: {
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
      nix = {
        settings = {
          max-jobs = 2;
          cores = if hostArch == "arrowlake" then 8 else 4;

          auto-optimise-store = true;
          trusted-users = [ "ben" ];
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          ssl-cert-file = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

          # Perhaps one day...
          # substituters = pkgs.lib.mkForce [ ];

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

        # Needed for Nix >= 2.35 for massive improvements in memory usage which avoids bringing the
        # system to its knees on large rebuilds. This is typically an issue when doing full system
        # updates that includes changes to deep transitive dependencies like xgcc, tcc, or perl.
        package = pkgs.nixVersions.latest;

        # Ensure the nixpkgs channel always tracks this flake's input and not some random channel
        # URL. This serves primarily as a safeguard against dumb nix scripts and some funny
        # business when dealing with determinate-nix
        registry.nixpkgs = {
          exact = true;
          from = {
            type = "indirect";
            id = "nixpkgs";
          };
          flake = inputs.nixpkgs;
        };

        # To prevent long-running nix updates from impacting system responsiveness
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
      };

      nixpkgs = {
        hostPlatform = {
          system = "x86_64-linux";
          gcc.arch = hostArch;
          gcc.tune = hostArch;
        };

        config.allowUnfree = true;

        overlays = [
          inputs.nur.overlays.default

          self.overlays.valkey
          self.overlays.dolphin
          self.overlays.afdko
          self.overlays.kdoctools
          self.overlays.qtbase
          self.overlays.scipy
          self.overlays.zopfli-py
          self.overlays.electron-bin
          self.overlays.libjpeg_turbo
        ];
      };

      # I already run nix builds with a limited number of jobs. Instead, let's just for a CPU
      # affinity for p-cores only
      systemd.services.nix-daemon.serviceConfig = {
        # If not arrowlake, then this system must be a skylake or coffee lake CPU which both
        # predate Intel's switch to a heterogeneous core architecture. Thus, we'll just allocate 8
        # cores as a sensible default.
        CPUAffinity = if hostArch == "arrowlake" then "0-15" else "0-7";

        # To avoid OOM and other terrible problems, force aggressive swapping past this limit
        MemoryHigh = if hostArch == "arrowlake" then "20G" else "40G";
      };

      services.nixseparatedebuginfod2.enable = true;

      environment.systemPackages = with pkgs; [
        nix-output-monitor
      ];

      programs.nh = {
        enable = true;
        # package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default;
        flake = "/home/ben/config"; # TODO: make better

        # Absolutely no automatic cleans. This will trash any progress during long system updates
      };
    };
}
