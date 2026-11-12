{ ... }: {
  flake.homeModules.discord =
    { config, ... }:
    let
      cfgDir = config.xdg.configHome;
    in
    {
      programs.discord = {
        enable = true;
        settings.SKIP_HOST_UPDATE = true;
      };

      # Since discord made a change and now it insists upon writing over the settings file
      home.file."${cfgDir}/${config.programs.discord.configName}/settings.json".force = true;
    };
}
