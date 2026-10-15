{ pkgs, ... }:
let
  unwrapped-pkg = pkgs.fastfetch-unwrapped.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [ ./battery_charge_max.patch ];

    checkPhase = ''
      ctest
    '';
  });
in
pkgs.fastfetch.override {
  fastfetch-unwrapped =
    assert unwrapped-pkg.version == "2.69.0"; # Because new versions often causes patch problems
    unwrapped-pkg;
}
