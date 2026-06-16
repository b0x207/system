import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property real barHeight: 35

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            required property var modelData
            screen: modelData
            color: "transparent"

            property real radius: 13
            property real borderWidth: 2
            property real paddingWidth: 15

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: root.barHeight

            RowLayout {
                id: barLayout
                anchors.fill: parent
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                anchors.topMargin: 5
                anchors.bottomMargin: 5
                spacing: 6

                Rectangle {
                    Layout.minimumWidth: clockWidget.implicitWidth + window.paddingWidth * 2
                    Layout.fillHeight: true
                    radius: window.radius
                    color: Theme.base
                    border.color: Theme.border
                    border.width: window.borderWidth

                    ClockWidget { id: clockWidget }
                }
                Rectangle {
                    Layout.minimumWidth: workspaceWidget.implicitWidth + 30
                    Layout.fillHeight: true
                    radius: window.radius
                    color: Theme.base
                    border.color: Theme.border
                    border.width: window.borderWidth

                    WorkspaceWidget {
                        id: workspaceWidget
                    }
                }

                SpacerWidget {}

                TrayWidget {}

                Rectangle {
                    Layout.minimumWidth: networkWidget.implicitWidth + window.paddingWidth * 2
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignRight
                    radius: window.radius
                    color: Theme.base
                    border.color: Theme.border
                    border.width: window.borderWidth

                    NetworkWidget { id: networkWidget }
                }

                Rectangle {
                    Layout.minimumWidth: volumeWidget.implicitWidth + window.paddingWidth * 2
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignRight
                    radius: window.radius
                    color: Theme.base
                    border.color: Theme.border
                    border.width: window.borderWidth

                    VolumeWidget { id: volumeWidget }
                }

                Rectangle {
                    visible: Hostname.value != "desktop"

                    Layout.minimumWidth: batteryWidget.implicitWidth + window.paddingWidth * 2
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignRight
                    radius: window.radius
                    color: Theme.base
                    border.color: Theme.border
                    border.width: window.borderWidth

                    BatteryWidget { id: batteryWidget }
                }
            }
        }
    }
}
