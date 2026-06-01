{...}: {
  flake.nixosModules.audio = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
  };
}
