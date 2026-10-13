{ ... }: {
  flake.modules.darwin.nix-homebrew = { config, ... }: {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "ben";
      autoMigrate = true;
      mutableTaps = false;
    };

    homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

    homebrew = {
      enable = true;
    };
  };
}
