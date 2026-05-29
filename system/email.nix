{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    thunderbird-bin

    # Web Accounts
    kdePackages.signond
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.signon-kwallet-extension

    kdePackages.kaccounts-providers
    kdePackages.kmail
    kdePackages.kmail-account-wizard
    kdePackages.kontact
    kdePackages.akonadi
    kdePackages.akonadi-calendar
    kdePackages.akonadi-contacts
    kdePackages.akonadi-mime
    kdePackages.akonadi-import-wizard

    kdePackages.kdepim-runtime
    kdePackages.kdepim-addons
  ];

  programs.kde-pim = {
    enable = true;
    kmail = true;
    kontact = true;
  };

  environment.sessionVariables = {
    XDG_DATA_DIRS = ["${pkgs.kdePackages.kdepim-runtime}/share"];
  };
}
