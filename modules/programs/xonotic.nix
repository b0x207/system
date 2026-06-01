{...}: {
  flake.nixosModules.xonotic = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      xonotic
    ];

    services.xonotic = {
      enable = true;
      openFirewall = true;
      settings = {
        hostname = "Ben's Xonotic $g_xonoticversion Server";
        sv_motd = "This is a test server";
        gametype = "ft";
        fraglimit = 0;
        timelimit = 0;
        leadlimit = 30; # You must thoroughly win
        rcon_password = "foo";
        # g_maplist = "implosion";

        # Make bots have their own team
        # g_balance_teams = 0;
        # g_balance_teams_prevent_unbalanced = 0;
        # g_maxplayers = 0;
        # bot_number = 20;
        # g_ca_teams = 4;
        g_nix = 1;
        # bot_vs_human = -1; # Negative for blue humans
      };
    };
  };
}
