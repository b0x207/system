{...}: {
  flake.nixosModules.tz-and-locale = {...}: {
    time.timeZone = "America/Los_Angeles";

    services.timesyncd = {
      enable = true;
      servers = [
        "0.pool.ntp.org"
        "1.pool.ntp.org"
      ];
    };

    i18n.defaultLocale = "en_US.UTF-8";
  };
}
