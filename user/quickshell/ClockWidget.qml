import QtQuick
import "."

Text {
    text: Time.time

    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text
}
