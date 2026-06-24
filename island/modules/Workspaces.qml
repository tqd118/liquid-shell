import QtQuick
import Quickshell.Hyprland
import "../../widgets"

Item {
    id: root
    width: 100
    height: 20

    readonly property int count: 5
    property int activeIndex: (Hyprland.focusedWorkspace?.id || 1) - 1

    readonly property real cellW: 20
    readonly property real cellH: 20
    readonly property real spacing: 0
    readonly property real rowY: 9.5

    function centerXOf(index) {
        return index * (cellW + spacing) + cellW / 2 - 0.5
    }

    LiquidHighlight {
        id: highlight
        diameter: 20
        centerY: root.rowY
        fillColor: "#6478c8"
    }

    Repeater {
        model: 5

        delegate: Item {
            id: workspace
            readonly property int wsId: index + 1

            width: root.cellW
            height: root.cellH
            x: index * (root.cellW + root.spacing)
            y: 0

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = "${index + 1}" })`)
            }

            Text {
                anchors.centerIn: parent
                text: index + 1
                font.pixelSize: 14
                font.bold: index === root.activeIndex
                color: index === root.activeIndex ? "white" : "#cfd6ff"
                z: 2
            }
        }
    }

    Component.onCompleted: {
        highlight.animateTo(centerXOf(activeIndex), rowY)
    }

    onActiveIndexChanged: highlight.animateTo(root.centerXOf(activeIndex), root.rowY)
}