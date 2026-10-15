# Jun 11 2026:
# Build failure caused by kdoctools not liking GCC -march
{ inputs, ... }: {
  flake.overlays.kdoctools =
    _final: prev:
    let
      plain-pkgs = import inputs.nixpkgs { inherit (prev.stdenv.hostPlatform) system; };
    in
    {
      kdePackages = prev.kdePackages.overrideScope (
        _kde-final: _kde-prev: {
          kdoctools = plain-pkgs.kdePackages.kdoctools;
        }
      );
    };
}
