# Test scipy/signal/tests/test_spectral.py::TestSTFT::test_roundtrip_scaling fails. Since it builds
# correctly on normal nixpkgs, we'll assume that the test failure is due to a difference in codegen
# due to enabling F16C.
#
# The package also likes to ignore parallelism requirements. We can put it back into shape with a
# fairly simple fix, though.
#
# TRACK: https://github.com/NixOS/nixpkgs/issues/216033
{ nixpkgs, system }:
_final: prev:
let
  plain-pkgs = import nixpkgs { inherit system; };
in
{
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      _python-final: python-prev:
      let
        plain-pkg = plain-pkgs.${python-prev.python.pythonAttr + "Packages"}.scipy;
      in
      {
        scipy = plain-pkg.overrideAttrs (prevAttrs: {
          preBuild = (prevAttrs.preBuild or "") + ''
            appendToVar pypaBuildFlags "-Ccompile-args=-j$NIX_BUILD_CORES"
          '';
        });
      }
    )
  ];
}
