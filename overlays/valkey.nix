{}: final: prev: {
  valkey = prev.valkey.overrideAttrs (
    oldAttrs:
      assert oldAttrs.version == "9.1.1"; {
        doCheck = false;
        checkPhase = (
          builtins.replaceStrings
          ["--skipunit integration/aof-multi-part"]
          ["--skipunit integration/aof-multi-part \\\n  --skipunit unit/cluster/slot-migration"]
          oldAttrs.checkPhase
        );
      }
  );
}
