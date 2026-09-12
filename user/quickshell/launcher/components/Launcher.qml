import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: window

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    aboveWindows: true
    exclusionMode: ExclusionMode.Ignore
    focusable: true

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.layer: WlrLayer.Overlay

    color: "transparent"

    Item {
        anchors.fill: parent

        Shortcut {
            sequence: "Esc"
            onActivated: Qt.quit()
        }

        Rectangle {
            implicitWidth: 300
            implicitHeight: 300
            anchors.centerIn: parent

            color: "red"
        }
    }
}
