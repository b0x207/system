import QtQuick
import Quickshell.Services.UPower

Text {
    property int percent: {
        Math.round(UPower.displayDevice.percentage * 100)
    }
    property string icon: {
        let normal_set = [
            "\udb80\udc8e",
            "\udb80\udc7a",
            "\udb80\udc7b",
            "\udb80\udc7c",
            "\udb80\udc7d",
            "\udb80\udc7e",
            "\udb80\udc7f",
            "\udb80\udc80",
            "\udb80\udc81",
            "\udb80\udc82",
            "\udb80\udc79"
        ];
        let charging_set = [
            "\udb82\udc9f",
            "\udb82\udc9c",
            "\udb80\udc86",
            "\udb80\udc87",
            "\udb80\udc88",
            "\udb82\udc9d",
            "\udb80\udc89",
            "\udb82\udc9e",
            "\udb80\udc8a",
            "\udb80\udc8b",
            "\udb80\udc85"
        ];
        let is_charging = UPower.displayDevice.timeToEmpty == 0;

        if (is_charging) {
            charging_set[Math.floor(percent / 10)]
        } else {
            normal_set[Math.floor(percent / 10)]
        }
    }

    text: {
        let formattedPercent = `${percent}`.length > 2 ? `${percent}` : `${percent}`;

        `${formattedPercent}% ${icon}`
    }

    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text
}
