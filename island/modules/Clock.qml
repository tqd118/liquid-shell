import QtQuick
import Quickshell

Item {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes 
    }

    Text {
        text: Qt.formatDateTime(clock.date, "hh : mm")
        color: "#ebdbb2"
        font.pixelSize: 14
        font.bold: true
        anchors.centerIn: parent
    }
}