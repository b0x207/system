import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

pragma ComponentBehavior: Bound

Rectangle {
    id: trayWidgetContainer

    property real innerHeight: parent.height - window.borderWidth * 2
    property real iconSize: innerHeight - 2
    property var activeMenu: null

    Layout.minimumWidth: trayWidget.implicitWidth + window.paddingWidth * 2
    Layout.fillHeight: true
    radius: window.radius
    color: Theme.base
    border.color: Theme.border
    border.width: window.borderWidth

    // Hide the widget entirely if there is nothing in the system tray
    Binding on Layout.maximumWidth {
        when: SystemTray.items.values.length == 0
        value: 0
    }

    RowLayout {
        id: trayWidget
        anchors.fill: parent
        spacing: trayWidgetContainer.iconSize / 2

        Layout.fillWidth: true
        Layout.fillHeight: true

        SpacerWidget {}

        Repeater {
            model: SystemTray.items

            Item {
                id: trayIcon
                required property SystemTrayItem modelData
                property bool isOpen: false

                Layout.preferredWidth: trayWidgetContainer.iconSize
                Layout.preferredHeight: trayWidgetContainer.iconSize

                QsMenuOpener {
                    id: trayMenuOpener
                    menu: modelData.menu
                }

                Image {
                    source: modelData.icon
                    height: trayWidgetContainer.iconSize
                    width: trayWidgetContainer.iconSize

                    MouseArea {
                        enabled: true
                        anchors.fill: parent
                        onClicked: event => {
                            if (event.button == Qt.RightButton) {
                                modelData.activate();
                            } else if (event.button == Qt.LeftButton) {
                                if (trayIcon.isOpen) {
                                    trayIcon.isOpen = false;
                                    return;
                                }

                                trayMenuOpener.menu = trayIcon.modelData.menu;
                                trayWidgetContainer.activeMenu = itemMenu;

                                const window = QsWindow.window;
                                const widgetRect = window.contentItem.mapFromItem(trayIcon, 0, 0);
                                widgetRect.y = QsWindow.contentItem.height;
                                itemMenu.anchor.rect = widgetRect;
                                trayIcon.isOpen = true;
                            }
                        }
                    }
                }

                TrayMenuList {
                    id: itemMenu
                    trayItem: trayIcon.modelData.menu
                    visible: itemMenu == trayWidgetContainer.activeMenu && trayIcon.isOpen
                }
            }
        }

        SpacerWidget {}
    }
}
