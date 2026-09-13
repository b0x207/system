{ ... }: {
  flake.nixosModules.ghostty = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ghostty ];
  };

  flake.homeModules.ghostty =
    { pkgs, ... }:
    let
      pkg = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    in
    {
      home.packages = [ pkg ];

      programs.ghostty = {
        enable = true;
        package = pkg;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = {
          auto-update = "off";
          background-opacity = 0.9;
          link-previews = "osc8";
          clipboard-read = "allow";
          clipboard-write = "allow";
          gtk-single-instance = false;
          shell-integration-features = "ssh-terminfo,ssh-env,sudo";
          font-family = "JetBrainsMono Nerd Font Mono";
        };
      };
    };
}
