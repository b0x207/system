# Apr 17 2026:
# What a waste of literal days of my life. I've tried everything under the sun, but I can't seem
# to get the overlay for qtbase to work right with `-march`. So, I give up. Perhaps I will return
# at a later date (when some other problem inevitable crops up from this choice).
#
# For QT5, the qtbase package has problems with conditional compilation selecting multiple
# implementations.
#
# On QT6, the configure phase produces results such as:
# ```
# -- Performing Test AVX512VBMI2 intrinsics
# -- Performing Test AVX512VBMI2 intrinsics - Success
# ```
# Which is simply wrong. Unfortunately, this results in the generated binaries using AVX512 which
# then fail with illegal instruction errors for obvious reasons.
#
# Apr 18 2026:
# This is a better solution for QT6, however, it is dependent upon overrideScope preserving the
# override attribute.
#
# TRACK: https://github.com/NixOS/nixpkgs/issues/447012
#
# Prior attempt at using override scope:
#
# qt6 = prev.qt6.overrideScope (scope-final: scope-prev: {
#   qtbase = scope-prev.qtbase.overrideAttrs (prevAttrs: {
#     env.NIX_CFLAGS_COMPILE = plain-pkgs.lib.debug.traceVal (
#       prevAttrs.env.NIX_CFLAGS_COMPILE
#     );
#     patches = (prevAttrs.patches or []) ++ [
#       ../packages/qtbase/avx512.patch
#     ];
#
#     cmakeFlags = plain-pkgs.lib.debug.traceVal (prevAttrs.cmakeFlags or []) ++ [
#       "-DQT_FEATURE_avx512f=OFF"
#     ];
#
#     postPatch= ''
#     echo -e "\n\n\n\nfoo\n\n\n\n"
#
#     '' + (prevAttrs.postPatch or "");
#   });
# });
# qt6 = prev.qt6.overrideScope (scope-final: scope-prev: {
#   qtbase = scope-prev.qtbase.overrideAttrs (prevAttrs: {
#   });
# });
{ nixpkgs, system }:
_final: prev:
let
  plain-pkgs = import nixpkgs { inherit system; };
in
{
  qt6 = plain-pkgs.qt6; # Unfortunately, really aggressive but necessary without overrideScope
  qt5 = prev.qt5.overrideScope (
    _qt-final: _qt-prev: {
      qtbase = plain-pkgs.qt5.qtbase;
    }
  );
}
