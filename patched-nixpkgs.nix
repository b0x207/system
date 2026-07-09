# Yes, this makes use of IFD but since it happens so early in the evaluation phase, it should have
# a mostly negligible impact on build times
{
  nixpkgs,
  system,
}: let
  pkgs = import nixpkgs {inherit system;};
  patched-nixpkgs-src = pkgs.stdenv.mkDerivation (
    let
      patches = [
        # ./nixpkgs-patches/arrow-cpp.patch
        # ./nixpkgs-patches/aiocache.patch
        # ./nixpkgs-patches/qtbase-qt6.patch
      ];
    in {
      pname = "patched-nixpkgs";
      version = "${nixpkgs.shortRev}-patched";
      src = nixpkgs.sourceInfo.outPath;

      nativeBuildInputs = [pkgs.git];

      phases = [
        "unpackPhase"
        "buildPhase"
        "installPhase"
      ];

      buildPhase = ''
        git apply --verbose ${pkgs.lib.concatStringsSep " " patches}
      '';

      installPhase = ''
        cp -r . $out
      '';
    }
  );

  # This is some pretty hacky stuff...
  # Since `builtins.getFlake` won't allow passing store paths as inputs, the only solution is
  # to resort to trickery. Here, we add in the bare minimum required attributes to pretend that
  # this is an actual flake input.
  flake =
    (import "${patched-nixpkgs-src}/flake.nix")
    // {
      outPath = "${patched-nixpkgs-src}";
    };
in
  flake.outputs {self = flake;}
  // {
    inherit (patched-nixpkgs-src) outPath;
  }
