{ ... }: {
  flake.homeModules.git = { config, pkgs, ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "Ben Landon";
          email = "me@b0x207.dev";
        };
        init.defaultBranch = "main";
        gpg.ssh.allowedSignersFile = "~/.config/git/allowed-signers";
        credential = {
          helper = [
            "cache --timeout 21600"
            "oauth"
          ];
          "https://git.b0x207.dev" = {
            oauthClientId = "a4792ccc-144e-407e-86c9-5e7d8d9c3269";
            oauthAuthURL = "/login/oauth/authorize";
            oauthTokenURL = "/login/oauth/access_token";
          };
          "https://git.alugatuci.org" = {
            oauthClientId = "a4792ccc-144e-407e-86c9-5e7d8d9c3269";
            oauthAuthURL = "/login/oauth/authorize";
            oauthTokenURL = "/login/oauth/access_token";
          };
        };
      };
      signing = {
        format = "ssh";
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
      };
      includes = [
        {
          condition = "gitdir:~/school/";
          contents = {
            user.email = "blandon1@uci.edu";
          };
        }
      ];
    };

    programs.git-credential-oauth = {
      enable = true;
    };

    xdg.configFile."git/allowed-signers" = {
      enable = true;
      force = true;
      text =
        "${config.programs.git.settings.user.email} "
        + "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnyx15yATERx55O38TsVldST7u2eXX8fAsv15L6AhLE";
    };
  };
}
