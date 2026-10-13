pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: hyprsubmap_singleton

    property var active_submap: null

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name != "submap") {
                return;
            }

            if (event.data.length != 0) {
                hyprsubmap_singleton.active_submap = `Submap: ${event.data}`;
            } else {
                hyprsubmap_singleton.active_submap = null;
            }
        }
    }
}
