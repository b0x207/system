{ pkgs, inputs, ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
    };
    profiles.default = {
      name = "Default";
      settings = {
        "identity.fxaccounts.enabled" = true;
        "identity.fxaccounts.account.device.name" = "desktop";
        "extensions.autoDisableScopes" = 0;
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;
        "devtools.toolbox.host" = "right";
        #"browser.startup.homepage" = "file://" + (toString ./firefox/start.html);
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.download.open_pdf_attachments_inline" = true;

        # Always ask for a location before saving a download
        "browser.download.useDownloadDir" = false;
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
          karakeep
        ];
        settings."uBlock0@raymondhill.net".settings = {
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
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
        in baseConfig // {
          settings = {
            autoExpandTabs = true;
            autoExpandTabsOnNew = true;
            colorizeTabs = true;
            colorizeTabsBranchesSrc = "domain";
            colorizeTabsSrc = "container";
            ctxMenuNative = true;
            fontSize = "s";
            hideInact = true;
            previewTabs = true;
            tabsPanelSwitchActMove = true;
            markWindow = true;
            markWindowPreface = "[Sidebery]";
          };
          sidebarCSS = builtins.readFile ./firefox/sidebery.css;
        };
      };
      userChrome = builtins.readFile ./firefox/userChrome.css;
    };
  };
}
