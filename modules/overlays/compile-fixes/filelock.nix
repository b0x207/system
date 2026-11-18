# Nov 15 2026
# The filelock package already has a number of tests that are too flaky. This just adds one more.
{ ... }: {
  flake.overlays.filelock = _final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (_python-final: python-prev: {
        filelock = python-prev.filelock.overrideAttrs (prevAttrs: {
          disabledTests = (prevAttrs.disabledTests or [ ]) ++ [
            "test_strict_soft_doorway_preserves_every_claim_cleanup_error"
          ];
        });
      })
    ];
  };
}
