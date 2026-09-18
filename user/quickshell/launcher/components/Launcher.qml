import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "."

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
            implicitWidth: mainLayout.implicitWidth + 2 * this.border.width + 2 * mainLayout.anchors.margins
            implicitHeight: mainLayout.implicitHeight + 2 * this.border.width + 2 * mainLayout.anchors.margins
            anchors.centerIn: parent

            color: Qt.rgba(0.1, 0.1, 0.1, 0.7)
            radius: 20
            border.color: Qt.rgba(1, 1, 1, 0.7)
            border.width: 5

            ColumnLayout {
                id: mainLayout
                anchors.fill: parent
                anchors.margins: 20
                spacing: 6

                Text {
                    Layout.alignment: Qt.AlignHCenter

                    text: "Run Program"
                    color: "white"
                    font.pointSize: 12
                }

                TextField {
                    id: filterField

                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true

                    focus: true
                    placeholderText: "Search..."

                    onAccepted: {
                        // A lua config is required
                        if (entryList.currentIndex >= 0) {
                            let entry = entryList.model.values[entryList.currentIndex];
                            console.log(entry.command);
                            let joinedCommand = entry.command.join(" ");
                            Hyprland.dispatch(`hl.dsp.exec_cmd("${joinedCommand}")`);
                            // Qt.quit();
                        }
                    }
                }

                ListView {
                    id: entryList

                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.minimumHeight: 100
                    Layout.minimumWidth: 300

                    model: ScriptModel {
                        values: {
                            return [...DesktopEntries.applications.values]
                                .sort((a, b) => a.name.localeCompare(b.name))
                                .filter((entry) => entry.name.startsWith(filterField.text));
                        }
                    }
                    highlight: Rectangle {
                        color: Qt.rgba(0.1, 0.5, 1.0, 0.5)
                    }
                    highlightMoveDuration: 50
                    highlightMoveVelocity: -1
                    focus: true
                    clip: true

                    delegate: Text {
                        required property DesktopEntry modelData

                        width: ListView.view.width
                        color: "white"

                        text: modelData.name
                    }
                }
            }
        }
    }
}
