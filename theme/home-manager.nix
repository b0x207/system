{pkgs, ...}: {
  gtk = {
    enable = true;

    gtk4 = {
      enable = true;
      colorScheme = "dark";
    };
  };

  home.file.".config/dolphinrc".text = ''
    MenuBar=Disabled

    [ContentDisplay]
    UsePermissionsFormat=CombinedFormat

    [ContextMenu]
    ShowCopyMoveMenu=true

    [DetailsMode]
    RightPadding=3

    [General]
    BrowseThroughArchives=true
    EditableUrl=true
    RememberOpenedTabs=false
    ShowFullPathInTitlebar=true
    ShowStatusBar=FullWidth
    ShowZoomSlider=true
    Version=202
    ViewPropsTimestamp=2026,2,15,12,45,0.295

    [IconsMode]
    PreviewSize=128

    [KFileDialog Settings]
    Places Icons Auto-resize=false
    Places Icons Static Size=22

    [MainWindow]
    MenuBar=Disabled

    [PreviewSettings]
    Plugins=appimagethumbnail,audiothumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,heif,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,opendocumentthumbnail,svgthumbnail,textthumbnail

    [UiSettings]
    ColorScheme=BreezeDark

    [General]
    ColorScheme=BreezeDark
  '';

  home.file.".config/kdeglobals".text = ''
    [KDE]
    ShowDeleteCommand=false
    lookAndFeelPackage=org.kde.breezedark.desktop

    [KFileDialog Settings]
    Allow Expansion=false
    Automatically select filename extension=true
    Breadcrumb Navigation=true
    Decoration position=2
    Show Full Path=false
    Show Inline Previews=true
    Show Preview=false
    Show Speedbar=true
    Show hidden files=false
    Sort by=Name
    Sort directories first=true
    Sort hidden files last=false
    Sort reversed=false
    Speedbar Width=148
    View Style=DetailTree

    [PreviewSettings]
    EnableRemoteFolderThumbnail=false
    MaximumRemoteSize=0

    [Icons]
    Theme=breeze-dark

    [UiSettings]
    ColorScheme=BreezeDark

    [General]
    ColorScheme=BreezeDark
  '';

  # home.file.".local/share/color-schemes/BreezeDark.colors".source =
  #   "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
  # home.file.".local/share/color-schemes/BreezeLight.colors".source =
  #   "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeLight.colors";
}
