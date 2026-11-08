{ ... }: {
  flake.nixosModules.fingerprint =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.fprintd =
        lib.throwIfNot (config.networking.hostName == "laptop")
          "fprintd configuration has only been setup for the laptop host"
          {
            enable = true;
            enablePam = false; # Disable till proven to work reliably

            tod = {
              enable = true;
              driver = pkgs.libfprint-2-tod1-broadcom-cv3plus;
            };
          };
    };
}
