{ ... }: {
  flake.nixosModules.multimedia-tools = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      gimp
      vimiv-qt
      mpv
      kdePackages.kdenlive
      # kopuz
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
