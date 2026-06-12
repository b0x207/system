{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
    };
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      name = "Default";
      settings = {
        # I want my bookmarks on my phone... I'll self host a better solution eventually
        "identity.fxaccounts.enabled" = true;
        "identity.fxaccounts.account.device.name" = "laptop";

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
      };
      extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          sidebery
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

        # Sidebery
        # moz-extension://fca2c735-f2ee-413d-a41e-4dafaafee37e/page.setup/setup.html
        # data obtained via inspect from 'about:debugging#/runtime/this-firefox'
        # and then extracted via `await browser.storage.local.get(null)`
        settings."{3c078156-979c-498b-8990-85f7987dd929}".settings = let
          # TODO: confirm that the path provided is actually in the nix store and not impure
          baseConfig = builtins.fromJSON (builtins.readFile ./firefox/sidebery-config.json);
        in
          baseConfig
          // {
            settings = {
              autoExpandTabs = true;
              autoExpandTabsOnNew = true;
              colorizeTabs = false;
              colorizeTabsBranchesSrc = "domain";
              colorizeTabsSrc = "container";
              ctxMenuNative = true;
              fontSize = "s";
              hideInact = true;
              previewTabs = true;
              tabsPanelSwitchActMove = true;
              markWindow = true;
              markWindowPreface = "[Sidebery]";
              syncName = "laptop";
              syncUseFirefox = true;
              newTabCtxReopen = true;
            };
            sidebarCSS = builtins.readFile ./firefox/sidebery.css;
          };
      };
      userChrome = builtins.readFile ./firefox/userChrome.css;
    };
  };
}
