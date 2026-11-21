# Nov 20 2026:
# There is currently a bug in nix that causes already build derivation outputs to invalidate
# `outputChecks` even when it shouldn't.
#
# TRACK: https://github.com/NixOS/nix/issues/16485
# TRACK: https://github.com/NixOS/nix/pull/16486
{ ... }: {
  flake.overlays.protobuf = _final: prev: {
    protobuf = prev.protobuf.overrideAttrs {
      outputChecks = { };
    };
  };
}
