{ pkgs, ... }:
pkgs.fastfetch.overrideAttrs (oldAttrs:
  assert oldAttrs.version == "2.63.1";
  {
  patches = (oldAttrs.patches or []) ++ [ ./battery_charge_max.patch ];

  checkPhase = ''
  ctest
  '';
})
