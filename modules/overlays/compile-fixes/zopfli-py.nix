# Oct 5, 2206
# Problems building on optimized systems. The easiest fix is to just turn off some compiler tricks
{ ... }: {
  flake.overlays.zopfli-py =
    _final: prev:
    let
      zopfli = prev.zopfli.overrideAttrs {
        CFLAGS = "-fno-tree-vectorize";
        CXXFLAGS = "-fno-tree-vectorize";
      };
    in
    {
      inherit zopfli;

      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (_python-final: python-prev: {
          zopfli = python-prev.zopfli.overrideAttrs {
            buildInputs = [
              # (if prev.stdenv.hostPlatform.is64bit then zopfli else plain-pkgs.pkgsi686Linux.zopfli)
              zopfli
            ];
          };
        })
      ];
    };
}
