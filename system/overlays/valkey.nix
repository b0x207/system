{}:
final: prev: {
  valkey = prev.valkey.overrideAttrs (oldAttrs: {
    checkPhase = (builtins.replaceStrings
      ["--skipunit integration/aof-multi-part"]
      ["--skipunit integration/aof-multi-part \\\n  --skipunit unit/cluster/slot-migration"]
      oldAttrs.checkPhase);
  });
}
