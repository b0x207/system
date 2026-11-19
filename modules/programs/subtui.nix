{ self, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.SubTUI = pkgs.buildGoModule {
      pname = "subtui";
      version = "2.14.3";

      src = pkgs.fetchFromGitHub {
        owner = "MattiaPun";
        repo = "SubTUI";
        rev = "v2.14.3";
        hash = "sha256-LuiWdTfuUsIPV3RhMup6XegZaATFko8cIPI0Xe/O2Sc=";
      };
      vendorHash = "sha256-XtTO9muHlPJu+BHk2+bt7M4tCNGud52cjAswCFpjv2w=";

      proxyVendor = true;

      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = [ pkgs.mpv ];

      ldflags = [
        "-s"
        "-w"
      ];

      postInstall = ''
        mv $out/bin/SubTUI $out/bin/subtui
      '';

      meta = with lib; {
        description = "A lightweight Subsonic TUI music player with scrobbling and mpv backend";
        homepage = "https://github.com/MattiaPun/SubTUI";
        license = licenses.mit;
        mainProgram = "subtui";
      };
    };
  };

  flake.homeModules.subtui = { pkgs, ... }: {
    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.SubTUI ];
  };
}
