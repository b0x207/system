import QtQuick
import Quickshell.Io

Text {
    id: governorWidgetText
    text: "Loading"

    property bool is_notable: false

    font.family: Theme.font
    font.pixelSize: 15
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text

    Process {
        id: governorProc

        command: ["cat", "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                switch (this.text.trim()) {
                case "powersave":
                    governorWidgetText.text = " Power Save";
                    break;
                case "performance":
                    governorWidgetText.text = "󱐋 Performance";
                    break;
                default:
                    governorWidgetText.text = "Balanced";
                    break;
                }

                governorWidgetText.is_notable = this.text.trim() != "performance";
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: governorProc.running = true
    }
}
