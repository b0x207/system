{...}: {
  flake.nixosModules.nvidia-gpu = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
    ];

    hardware.nvidia = {
      open = true;
      branch = "stable";
      modesetting.enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    # hardware.graphics = {
    #   enable = true;
    #   extraPackages = with pkgs; [
    #   ];
    # };
  };
}
