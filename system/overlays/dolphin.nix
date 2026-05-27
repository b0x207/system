# An overlay to fix the dolphin "Open With" menu.
# Modified from the original at https://github.com/rumboon/dolphin-overlay

{}:
final: prev: {
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: let
    kservice = prev.libsForQt5.__internalKF5.kservice;
    menu-path = "${kservice}/etc/xdg/menus/applications.menu";
  in {
    dolphin = prev.symlinkJoin {
      name = "dolphin-wrapped";
      paths = [ kprev.dolphin ];
      nativeBuildInputs = [ prev.makeWrapper ];
      postBuild = ''
        rm $out/bin/dolphin
        makeWrapper ${kprev.dolphin}/bin/dolphin $out/bin/dolphin \
          --set XDG_CONFIG_DIRS "${kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
          --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${menu-path}"
      '';
    };
  });
}
