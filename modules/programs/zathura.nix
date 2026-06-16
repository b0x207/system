{...}: {
  flake.homeModules.zathura = {pkgs, ...}: {
    programs.zathura = {
      enable = true;
      extraConfig = ''
        # For some reason, default-bg must be specified using HTML notation
        set default-bg "#000000ff"
        set default-fg "#ff0000"

        #set scroll-page-aware true
        set adjust-open width

        set recolor true
        set recolor-darkcolor "#ffffff"
        set recolor-lightcolor rgba(0,0,0,0.9)
        set recolor-keephue true

        # Keep original image colors
        set recolor-reverse-video true

        set database "sqlite"

        # Show a vertical scrollbar
        set guioptions 'v'

        set selection-clipboard clipboard
      '';
    };
  };
}
