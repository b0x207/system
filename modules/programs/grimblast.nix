{ ... }: {
  flake.nixosModules.grimblast = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      satty
      grimblast
    ];
  };
}
