{ ... }: {
  flake.modules.darwin.minecraft-server = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.openjdk25
      pkgs.ferium
    ];
  };
}
