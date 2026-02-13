{ pkgs, ... }:
pkgs.fastfetch.overrideAttrs {
  patches = [ ./battery_charge_max.patch ];
}
