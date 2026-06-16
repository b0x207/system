import Quickshell
import QtQuick

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            required property var modelData
            screen: modelData
            color: "transparent"

            property real radius: 13
            property real borderWidth: 2

            // anchors {
            //     top: true
            //     left: true
            //     right: true
            // }

            implicitHeight: 35
        }
    }
}
