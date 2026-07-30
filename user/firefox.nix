{
  osConfig,
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    policies = {
      DisableAppUpdate = true;
    };
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      name = "Default";
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.startup.page" = 1; # Don't reopen closed windows

        # I want my bookmarks on my phone... I'll self host a better solution eventually
        "identity.fxaccounts.enabled" = true;
        "identity.fxaccounts.account.device.name" = osConfig.networking.hostName;

        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
        "devtools.toolbox.host" = "right";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.download.open_pdf_attachments_inline" = true;

        # These never help and only cause annoying problems
        "browser.gesture.swipe.left" = "";
        "browser.gesture.swipe.right" = "";

        # Always ask for a location before saving a download
        "browser.download.useDownloadDir" = false;

        # Keep AI out of my browser please
        "browser.ai.control.default" = "blocked";

        # Use my preferred file picker instead
        # Note: values are 0=never, 1=always, 2=auto which really means flatpak
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.quickactions" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.trending" = false;

        # Just in case GTK dark mode doesn't work
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

        # Nvidia can be problematic
        "media.hardware-video-decoding.force-enabled" = true;

        # Why disable by default Mozilla?
        "dom.webgpu.enabled" = true;

        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "{446900e4-71c2-419f-a6a7-df9c091e268b},history,bookmarks";
        "sidebar.installed.extensions" = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
      };
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          # sidebery
          vimium
          redirect-shorts-to-youtube
          tasks-for-canvas
          violentmonkey
        ];
        settings."uBlock0@raymondhill.net".settings = {
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "easylist"
          ];
          netWhiteList = [
            "chrome-extension-scheme"
            "moz-extension-scheme"
            "b0x207.dev"
            "files.b0x207.dev"
            "git.b0x207.dev"
          ];
          privateAllowed = true;
        };
      };
      userChrome = builtins.readFile ./firefox/userChrome.css;
    };
  };
}
