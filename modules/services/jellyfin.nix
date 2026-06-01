{...}: {
  flake.nixosModules.jellyfin = {pkgs, ...}: {
    services.jellyfin = {
      enable = true;
      user = "ben";
      group = "users";
      hardwareAcceleration = {
        enable = true;
        type = "qsv";
        device = "/dev/dri/renderD128";
      };
      transcoding = {
        enableHardwareEncoding = true;
        enableSubtitleExtraction = true;
      };
    };

    users.users.ben.extraGroups = [
      "video"
      "render"
    ];

    hardware.graphics.extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-compute-runtime
    ];

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];
  };
}
