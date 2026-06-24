import QtQuick
import "modules"
import qs.state
import "content"

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
        width: IslandState.baseWidth
        height: IslandState.baseheight
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
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
