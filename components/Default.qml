import QtQuick
import qs.modules

Item {
    id: root
    anchors.fill: parent

    Clock {
        id: clock
        anchors.centerIn: parent
    }

    Workspaces {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
    }

    TrayList {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 36
    }
}