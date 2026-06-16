import QtQuick
import Quickshell.Hyprland

Text {
    text: Hyprland.focusedWorkspace.id

    font.family: Theme.font
    font.pixelSize: 15
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text
}
