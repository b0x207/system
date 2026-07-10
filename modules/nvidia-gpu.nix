{...}: {
  flake.nixosModules.nvidia-gpu = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
    ];

    hardware.nvidia = {
      open = true;
      branch = "stable";
      modesetting.enable = true;
      videoAcceleration = true;
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}
