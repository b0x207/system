{ ... }: {
  flake.nixosModules.ci-worker = { config, ... }: {
    # services.gradient.worker = {
    #   enable = true;
    #   id = "<worker id from step 1>";
    #   serverUrl = "wss://ci.b0x207.dev/proto";
    #   peersFile = config.age.secrets.ci-worker-peers;
    #   build.metrics = true;
    # };
  };
}
