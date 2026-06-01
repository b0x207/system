{inputs, ...}: {
  flake.nixosModules.tmux = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };
}
