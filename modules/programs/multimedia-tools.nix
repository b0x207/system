{...}: {
  flake.nixosModules.multimedia-tools = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      krita
      gimp
      vimiv-qt
      mpv
    ];

    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        obs-gstreamer
        obs-pipewire-audio-capture
      ];
    };
  };
}
