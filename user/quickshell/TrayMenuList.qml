import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: root
    anchor.window: window

    required property QsMenuHandle trayItem;

    implicitWidth: menuContainer.implicitWidth
    implicitHeight: menuContainer.implicitHeight

    // color: Theme.base
    color: "transparent"

    mask: Region {
        item: stack
    }

    function close(): void {
        trayIcon.isOpen = false;
        trayWidgetContainer.activeMenu = null;
    }

    Component.onCompleted: trayWidgetContainer.activeMenu = this

    HyprlandFocusGrab {
        id: grab
        windows: [ root ]

        onCleared: {
            root.close()
        }

        active: trayIcon.isOpen
    }

    // Heavily inspired by:
    // https://git.allpurposem.at/mat/quickbar/src/branch/main/Modules/TrayIcons/MenuList.qml

    component SubMenu: Column {
        id: menu

        required property QsMenuHandle handle
        property bool isSubMenu
        property bool shown

        padding: 3.0
        spacing: 3.0

        opacity: shown ? 1 : 0
        scale: shown ? 1 : 0.8

        Component.onCompleted: shown = true

        // TODO: behavior on scale

        QsMenuOpener {
            id: menuOpener
            menu: menu.handle
        }

        Repeater {
            model: menuOpener.children

            Rectangle {
                id: menuItem
                required property QsMenuEntry modelData

                implicitWidth: 220 // TODO configure
                implicitHeight: modelData.isSeparator ? 1 : 20

                color: modelData.isSeparator ? Theme.baseHover : "transparent"

                Loader {
                    id: children

                    anchors.left: parent.left
                    anchors.right: parent.right

                    active: !menuItem.modelData.isSeparator

                    sourceComponent: MouseArea {
                        id: mouseArea

                        acceptedButtons: Qt.AllButtons
                        implicitHeight: label.implicitHeight
                        implicitWidth: label.implicitWidth
                        hoverEnabled: true

                        Rectangle {
                            color: mouseArea.containsMouse ? Theme.baseHover : "transparent"
                            anchors.fill: parent
                        }

                        onClicked: {
                            const entry = menuItem.modelData;
                            if (entry.hasChildren) {
                                stack.push(subMenuComp.createObject(null, {
                                    handle: entry,
                                    isSubMenu: true
                                }));
                            } else {
                                menuItem.modelData.triggered();
                                root.close();
                            }
                        }

                        Loader {
                            id: icon

                            anchors.left: parent.left
                            active: menuItem.modelData.icon !== "" && this.sourceComponent.status != Image.Error

                            Component.onCompleted: {
                                console.log(this.sourceComponent.source, menuItem.modelData.icon);
                            }

                            sourceComponent: Image {
                                width: label.implicitHeight
                                height: label.implicitHeight

                                source: menuItem.modelData.icon
                                asynchronous: true
                            }
                        }

                        Text {
                            id: label

                            anchors.left: icon.right
                            anchors.leftMargin: icon.active ? 3.0 : 0

                            text: labelMetrics.elidedText
                            color: menuItem.modelData.enabled ? Theme.text : Theme.textDisabled
                            font.family: Theme.font
                            font.pixelSize: Theme.fontSize
                        }

                        TextMetrics {
                            id: labelMetrics
                            text: menuItem.modelData.text
                            font.pointSize: label.font.pointSize
                            font.family: label.font.family

                            elide: Text.ElideRight
                            elideWidth: 200 // TODO!!
                        }

                        Loader {
                            id: expand

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            active: menuItem.modelData.hasChildren

                            sourceComponent: Text {
                                text: ">"
                                color: menuItem.modelData.enabled ? Theme.text : Theme.textDisabled
                                font.family: Theme.font
                                font.pixelSize: Theme.fontSize
                            }
                        }
                    }
                }
            }
        }

        Loader {
            active: menu.isSubMenu

            sourceComponent: Item {
                implicitWidth: back.implicitWidth
                implicitHeight: back.implicitHeight + 20 // TODO: theme

                Item {
                    anchors.bottom: parent.bottom
                    implicitWidth: back.implicitWidth
                    implicitHeight: back.implicitHeight

                    MouseArea {
                        id: backMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            stack.pop();
                        }

                        Rectangle {
                            color: backMouseArea.containsMouse ? Theme.baseHover : "transparent"
                            anchors.fill: parent

                            Row {
                                id: back
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "<"
                                    color: Theme.text
                                    font.family: Theme.font
                                    font.pixelSize: Theme.fontSize
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Back"
                                    color: Theme.text
                                    font.family: Theme.font
                                    font.pixelSize: Theme.fontSize
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: menuContainer
        color: Theme.base
        implicitWidth: stack.implicitWidth + this.border.width * 2
        implicitHeight: stack.implicitHeight + this.border.width * 2
        border {
            color: Theme.border
            width: 5
        }
        radius: 10

        StackView {
            id: stack

            anchors.fill: menuContainer
            anchors.topMargin: menuContainer.border.width
            anchors.leftMargin: menuContainer.border.width

            implicitWidth: currentItem.implicitWidth
            implicitHeight: currentItem.implicitHeight

            initialItem: SubMenu {
                id: subMenu
                isSubMenu: false
                handle: root.trayItem
            }
        }

        Component {
            id: subMenuComp

            SubMenu {}
        }
    }
}
