import QtQuick

import qs.modules
import qs.theme

Item {
    anchors.fill: parent

    TrayList {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        expanded: true

        Rectangle {
            anchors.fill: parent
            z: -1
            color: "transparent"

            border.width: 2
            border.color: Theme.foreground
            radius: 12
        }
    }
}