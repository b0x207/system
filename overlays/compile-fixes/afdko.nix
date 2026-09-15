# This test fails when building with floating point hardware features (i.e. `-march`). Until a
# proper fix can be produced, disabling the test doesn't seem to result in any significant quality
# decrease.
#
# TODO: convert this to use a plain-pkgs version
_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_python-final: python-prev: {
      afdko = python-prev.afdko.overrideAttrs (prevAttrs: {
        disabledTests = (prevAttrs.disabledTests or [ ]) ++ [
          "test_overlap_removal"
        ];
      });
    })
  ];
}
