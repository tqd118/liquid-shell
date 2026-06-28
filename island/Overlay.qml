import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.state

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: IslandState.isKbFocusNeeded ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore

    mask: Region {
        item: island.shapeItem
    }

    Island {
        id: island
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 3
    }
}
