import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Text {
    id: networkWidget
    property bool hasWifi: false
    property bool hasEthernet: false
    property string wifiNetwork
    property string ethernetNetwork

    font.family: Theme.font
    font.pixelSize: 15
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text

    text: {
        if (hasEthernet && !hasWifi) {
            return "󰈀 Ethernet Connected";
        }
        if (!hasWifi && !hasEthernet) {
            return "󰖪 No Internet";
        }

        let content = "";
        if (hasEthernet) {
            content += "󰈀  ";
        }

        return `${content}  ${wifiNetwork}`;
    }

    Process {
        id: monitorProc
        running: true
        command: ["nmcli", "monitor"]

        stdout: SplitParser {
            onRead: (data) => {
                const getName = (input) => {
                    let first = input.indexOf("'");
                    let second = input
                    .split("")
                    .reverse()
                    .join("")
                    .indexOf("'");

                    if (first < 0 || second < 0) {
                        return "";
                    }

                    return input.substring(first, second + 1);
                };

                if (data.includes(":")) {
                    // There was a device-specific event
                    let is_eth_dev = data.includes("enp");
                    let is_wifi_dev = data.includes("wlp");
                    let is_unavailable = data.includes("unavailable");
                    let is_disconnected = data.includes("disconnected");
                    let is_connected = data.includes("connected") && !is_disconnected;

                    if (is_eth_dev && (is_unavailable || is_disconnected)) {
                        hasEthernet = false;
                        ethernetNetwork = "";
                    }
                    if (is_eth_dev && is_connected) {
                        hasEthernet = true;
                        networkInfoProc.running = true;
                    }

                    if (is_wifi_dev && (is_unavailable || is_disconnected)) {
                        hasWifi = false;
                        wifiNetwork = "";
                    }
                    if (is_wifi_dev && is_connected) {
                        hasWifi = true;
                        networkInfoProc.running = true;
                    }
                }
            }
        }
    }

    // Exists to initalize the state of the widget when it is created
    Process {
        id: networkInfoProc
        running: true
        command: ["nmcli", "-t", "-f", "NAME,TYPE,DEVICE", "connection", "show"]

        stdout: StdioCollector {
            onStreamFinished: {
                let entries = this.text.split("\n");
                for (let i = 0; i < entries.length; i++) {
                    let entry = entries[i];

                    if (entry == "") {
                        continue;
                    }
                    let [name, type, device] = entry.split(":");

                    if (device == "" || device == "lo") {
                        continue;
                    }

                    if (type.includes("wireless")) {
                        networkWidget.hasWifi = true;
                        networkWidget.wifiNetwork = name;
                    } else if (type.includes("ethernet")) {
                        networkWidget.hasEthernet = true;
                        networkWidget.ethernetNetwork = name;
                    }
                }
            }
        }
    }
}
