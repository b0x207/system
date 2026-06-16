pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string value;

    Process {
        running: true
        command: [ "hostname" ]
        stdout: StdioCollector {
            onStreamFinished: {
                value = this.text.trim();
            }
        }
    }
}
