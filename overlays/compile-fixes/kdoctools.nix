# Jun 11 2026:
# Build failure caused by kdoctools not liking GCC -march
{ nixpkgs, system }:
_final: prev:
let
  plain-pkgs = import nixpkgs { inherit system; };
in
{
  kdePackages = prev.kdePackages.overrideScope (
    _kde-final: _kde-prev: {
      kdoctools = plain-pkgs.kdePackages.kdoctools;
    }
  );
}
