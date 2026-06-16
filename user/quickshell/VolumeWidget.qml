import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Text {
    PwObjectTracker {
        objects: [ Pipewire, Pipewire.defaultAudioSink ]
    }

    property bool isMuted: Pipewire.defaultAudioSink.audio.muted
    property int volume: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
    property string icon: {
        if (isMuted) {
            " "
        } else if (volume == 0) {
            ""
        } else if (volume <= 50) {
            " "
        } else {
            " "
        }
    }

    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent
    color: Theme.text

    text: {
        let formattedVolume = `${volume}`.length > 2 ? `${volume}` : ` ${volume}`;
        `${formattedVolume}% ${icon}`
        // `${formattedVolume}% VOL`
    }
}
