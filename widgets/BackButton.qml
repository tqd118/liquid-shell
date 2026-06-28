import QtQuick

Rectangle {
    id: root 

    property color baseColor
    property color hoverColor
    property color arrowColor

    property var onClick

    width: 28
    height: 28
    radius: 8

    color: backMouseArea.containsMouse ? hoverColor : baseColor
    border.color: "#454b58"
    border.width: 1
    anchors.verticalCenter: parent.verticalCenter

    Text {
        anchors.centerIn: parent
        text: "←"
        color: root.arrowColor
        font.pixelSize: 16
        font.bold: true
    }

    MouseArea {
        id: backMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.onClick()
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }
}