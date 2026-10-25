# Oct 24, 2206
# Problems building on optimized systems. The easiest fix is to just turn off some compiler tricks
#
# This is derived from
# commit 36956793b60deb2d1169d1432be6d19871f5ecb1 in CMakeLists.txt#L1080
{ ... }: {
  flake.overlays.libjpeg_turbo = _final: prev: {
    libjpeg_turbo = prev.libjpeg_turbo.overrideAttrs (oldAttrs: {
      cmakeFlags =
        (oldAttrs.cmakeFlags or [ ])
        ++ prev.lib.optionals prev.stdenv.hostPlatform.isx86_64 [
          (prev.lib.cmakeFeature "FLOATTEST12" "fp-contract")
        ]
        ++ prev.lib.optionals prev.stdenv.hostPlatform.isi686 [
          (prev.lib.cmakeFeature "FLOATTEST12" "387")
        ];
    });
  };
}
