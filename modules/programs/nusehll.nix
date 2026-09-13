{ ... }: {
  flake.homeModules.nushell = { pkgs, ... }: {
    home.shell.enableNushellIntegration = true;

    programs.nushell = {
      enable = true;
      extraConfig = ''
        # $env.config.hooks.command_not_found = source ${pkgs.nix-index}/etc/profile.d/command-not-found.nu
      '';
    };
  };
}
