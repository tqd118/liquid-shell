import QtQuick

Item {
    id: root
    width: 30
    height: 20

    property real displayValue
    property alias color: counterText.color
    property alias fontSize: counterText.font.pixelSize

    Text {
        id: counterText

        anchors.centerIn: parent
        text: Math.round(root.displayValue) 
        font.bold: true

        font.pixelSize: 14

        onTextChanged: pulse.restart()
    }

    SequentialAnimation {
        id: pulse
        running: false

        NumberAnimation {
            target: counterText
            property: "scale"
            to: 0.92
            duration: 60
            easing.type: Easing.OutQuad
        }

        NumberAnimation {
            target: counterText
            property: "scale"
            to: 1
            duration: 90
            easing.type: Easing.OutCubic
        }
    }
}
