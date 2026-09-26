{ ... }: {
  flake.nixosModules.email = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # TODO: consider switching to from source
      thunderbird-bin
    ];
  };
}
