import QtQuick
import qs.state

Item {
    id: root

    implicitWidth: IslandState.islandWidth
    implicitHeight: IslandState.islandHeigh

    // ── Жидкая форма ─────────────────────────────────────────────────────────

    LiquidShape {
        id: shape
        anchors.fill: parent
        rectWidth:  IslandState.islandWidth
        rectHeight: IslandState.islandHeigh
    }

    readonly property alias shapeItem: shape.shapeItem

    // ── Контент ───────────────────────────────────────────────────────────────

    Content {
        anchors.fill: parent
        z: 10
    }

    // ── Hover → деформация ────────────────────────────────────────────────────

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        onEntered: shape.deformT = 1.0
        onExited:  shape.deformT = 0.0

        onPositionChanged: function(mouse) {
            shape.cursorX = mouse.x
            shape.cursorY = mouse.y
        }
    }


}
