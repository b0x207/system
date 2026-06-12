{...}: {
  flake.nixosModules.core-system = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # Compression and archival tools
      zip
      unzip
      gnutar

      # For analyzing disk usage
      dust

      # Basic documentation
      man-pages
      man-pages-posix

      # Must-have compilers and related tools
      clang
      clang-tools
      gcc
      glibc.dev
      python314

      # Misc basic utilities
      # TODO: clean up/modularize maybe?
      cacert
      ffmpeg-full
      wget
      file
      gnumake
      git
      unixtools.xxd
      coreutils-full
    ];

    # More extensive system documentation
    documentation = {
      enable = true;
      dev.enable = true;
      man = {
        enable = true;
        cache.enable = true;

        # Building the man cache takes a long time and doesn't change that often.
        # Rather than burden the build times, move the cost to a runtime systemd service
        cache.generateAtRuntime = true;
      };
    };
  };
}
