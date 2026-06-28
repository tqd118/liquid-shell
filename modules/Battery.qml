import QtQuick

import qs.theme
import qs.state
import qs.components
import qs.providers

Item {
    id: root

    Text {
        id: battery
        anchors.centerIn: parent
        font.pixelSize: 20

        color: Theme.foreground

        text: {
            if (PowerProvider.isFull)
                return ""

            const p = PowerProvider.percentage
            if (p >= 80) return ""
            if (p >= 60) return ""
            if (p >= 40) return ""
            if (p >= 20) return ""
            return ""
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: () => {
            IslandState.openComponent(Components.batteryInfo, 260, 120)
        }
    }
}