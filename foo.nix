{pkgs ? import <nixpkgs> {}}: let
  innerDrv = pkgs.stdenv.mkDerivation {
    name = "inner-drv";
    phases = ["buildPhase"];
    buildPhase = ''
      echo "Inner"
      echo foo > $out
    '';
  };

  # Then a derivation that depends on a dynamic output.
  dynDrv = pkgs.stdenv.mkDerivation {
    name = "dynamic-example";
    # This creates placeholders using nix-computed-output:...
    # referencing the CA derivation's placeholders
    buildCommand = ''
      ${builtins.outputOf (builtins.unsafeDiscardOutputDependency innerDrv) "out"}
    '';
  };
in
  innerDrv
