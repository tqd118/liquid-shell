import QtQuick
import qs.state
import qs.modules

Item {
    id: root

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
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
    }

    MouseArea {
        anchors.fill: parent
        onClicked: IslandState.toggle(400, 140);
    }
}
