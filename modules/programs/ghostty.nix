{ ... }: {
  flake.nixosModules.ghostty = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ghostty
    ];
  };

  flake.homeModules.ghostty = { ... }: {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        auto-update = "off";
        background-opacity = 0.9;
        link-previews = "osc8";
        clipboard-read = "allow";
        clipboard-write = "allow";
        gtk-single-instance = true;
        shell-integration-features = "ssh-terminfo,ssh-env,sudo";
        font-family = "JetBrainsMono Nerd Font Mono";
        theme = "Gruvbox Dark";
        quit-after-last-window-closed = false;
      };
    };
  };
}
