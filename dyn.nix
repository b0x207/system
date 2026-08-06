let
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/b7c2ada94fe99c15b0dbcf4d11fd7850b957a436.tar.gz") {
    system = "x86_64-linux";
  };
  producing =
    pkgs.runCommand "inner.drv" {
      outputHashMode = "text";
      requiredSystemFeatures = ["recursive-nix"];
    } ''
      echo "let pkgs = import \"${pkgs.path}\" {};
            in
            pkgs.runCommand \"inner\" {} '''
              sleep 10;
              echo \"Hello from inner!\" > \$out
            '''
            " > inner.nix
      cp $(${pkgs.nix}/bin/nix-instantiate inner.nix) $out
    '';
in (builtins.outputOf producing.outPath "out")
