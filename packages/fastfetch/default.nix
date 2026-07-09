{pkgs, ...}:
pkgs.fastfetch.overrideAttrs (
  oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [./battery_charge_max.patch];

    checkPhase = ''
      ctest
    '';
  }
)
