pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property int volume: _sink !== null && _sink.audio !== null
        ? Math.round(_sink.audio.volume * 100) : 0

    readonly property bool muted: _sink !== null && _sink.audio !== null
        ? _sink.audio.muted : false

    readonly property string icon: {
        if (root.muted) return "";
        if (root.volume > 80) {
            return "";
        } else if (root.volume > 40) {
            return "";
        } else {
            return "";
        }
    }

    signal providerVolumeChanged(int volume)

    function setVolume(value) {
        if (_sink === null || _sink.audio === null) return
        _sink.audio.volume = value / 100
    }

    function setMuted(muted) {
        if (_sink === null || _sink.audio === null) return
        _sink.audio.muted = muted
    }

    function toggleMute() {
        setMuted(!muted)
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property var _sink: Pipewire.defaultAudioSink

//    onVolumeChanged: {}
//    onMutedChanged: root.providerVolumeChanged(root.volume)

    Connections {
        target: root._sink ? root._sink.audio : null

        function onVolumeChanged() { root.providerVolumeChanged(root.volume) }
        function onMutedChanged()  { root.providerVolumeChanged(root.volume) }
    }
}
