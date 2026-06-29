import QtQuick
import QtQuick.Controls

import qs.state
import qs.widgets
import qs.services
import qs.theme

Item {
    id: root

    Timer {
        id: closetimer
        running: true
        interval: 1200
        onTriggered: IslandState.closeAll()
    }

    Text {
        id: icon 
        text: ""

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12

        font.pixelSize: 20
        color: AudioService.muted ? Theme.gray : Theme.foreground
    }

    Slider {
        id: slider
        from: 0
        to: 100 

        width: parent.width * .7
        anchors.centerIn: parent

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2

            implicitWidth: 180
            implicitHeight: 6
            
            width: slider.availableWidth
            height: implicitHeight

            radius: 3
            color: Theme.dark0Soft

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: AudioService.muted ? Theme.gray : Theme.accent
                radius: 3
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2

            implicitWidth: 6
            implicitHeight: 12

            radius: 3
            color: AudioService.muted ? Theme.gray : Theme.accent

            Behavior on color {
                ColorAnimation {duration: 150; easing.type: Easing.OutQuad}
            }
        }


        value: AudioService.volume
        onMoved: AudioService.setVolume(Math.round(value))
    }

    SmoothCounter {

        displayValue: AudioService.volume
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 6

        color: AudioService.muted ? Theme.gray : Theme.foreground
    }

    Connections {
        target: AudioService
        function onProviderVolumeChanged() {
            closetimer.restart()
        }
    }
}