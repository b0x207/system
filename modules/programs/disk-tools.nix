{...}: {
  flake.nixosModules.disk-tools = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kdePackages.partitionmanager
    ];
  };
}
