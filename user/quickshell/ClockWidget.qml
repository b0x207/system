import QtQuick
import '.'

Text {
    text: Time.time

    font.family: Theme.font
    font.pixelSize: 15
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text
}
