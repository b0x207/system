{...}: {
  flake.homeModules.ssh = {...}: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          addKeysToAgent = "yes";
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
        };
        "*.b0x207.dev" = {
          proxyCommand = "cloudflared access ssh --hostname %h";
        };
        "*.intercraft.nexus" = {
          proxyCommand = "cloudflared access ssh --hostname %h";
        };
        "openlab.ics.uci.edu" = {
          identityFile = "~/.ssh/id_uci";
          identitiesOnly = true;
          controlMaster = "auto";
          controlPath = "~/.ssh/%r@%h-%p";
          controlPersist = "10m";
          forwardAgent = true;
        };
        "archimedes-8.ics.uci.edu" = {
          port = 10010;
        };
      };
    };

    services.ssh-agent = {
      enable = true;
      defaultMaximumIdentityLifetime = 3600;
    };
  };
}
