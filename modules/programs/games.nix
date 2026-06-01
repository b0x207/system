{...}: {
  flake.nixosModules.games = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      modrinth-app
      jdk21 # for minecraft
      supertuxkart
      supertux
      beyond-all-reason
      warzone2100
    ];
  };
}
