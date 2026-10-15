{ ... }: {
  flake.nixosModules.sway-notification-center = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      swaynotificationcenter
    ];
  };

  flake.homeModules.sway-notification-center = { ... }: {
    services.swaync = {
      enable = true;

      settings = {
        positionX = "right";
        positionY = "top";
      };

      style = ./sway-notification-center.css;
    };
  };
}
