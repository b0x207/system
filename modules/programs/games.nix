{...}: {
  flake.nixosModules.games = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # modrinth-app
      jdk21 # for minecraft
      supertuxkart
      supertux
      beyond-all-reason
    ];

    programs.steam.enable = true;
  };

  flake.homeModules.games = {...}: {
    programs.prismlauncher.enable = true;
  };
}
