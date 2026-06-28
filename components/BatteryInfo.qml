import QtQuick
import qs.state
import qs.theme
import qs.widgets
import qs.providers

Item {
    anchors.fill: parent
    anchors.margins: 10

    Item {
        id: header 
        height: 40
        width: parent.width

        
        BackButton {
            id: backButton
            baseColor: Theme.accent
            hoverColor: Theme.accentDim
            arrowColor: Theme.light0Hard

            onClick: () => IslandState.closeAll()
        }

        Text {
            text: "Battery"
            color: Theme.foreground
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: backButton.right
            anchors.leftMargin: 8
            font.bold: true
        }
    }

    Column {
        id: info 
        width: parent.width
        anchors.top: header.bottom
        anchors.topMargin: 10

        Text {
            text: `Charge: ${PowerProvider.percentage}%`
            color: Theme.foreground
        }

        Text {
            text: `State: ${PowerProvider.stateString}`
            color: Theme.foreground
        }
    }
}