import QtQuick
import Quickshell.Hyprland

Text {
    text: HyprSubmap.active_submap

    font.family: Theme.font
    font.pixelSize: 15
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text
}
