import QtQuick
import qs.state

Item {
    id: root

    implicitWidth: IslandState.islandWidth
    implicitHeight: IslandState.islandHeigh

    LiquidShape {
        id: shape
        anchors.fill: parent
        rectWidth: IslandState.islandWidth
        rectHeight: IslandState.islandHeigh
    }

    readonly property alias shapeItem: shape.shapeItem

    Content {
        anchors.fill: parent
        z: 10
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

        onHoveredChanged: {
            shape.deformT = hovered ? 1.0 : 0.0
        }

        onPointChanged: {
            if (point) {
                shape.cursorX = point.position.x
                shape.cursorY = point.position.y
            }
        }
    }
}