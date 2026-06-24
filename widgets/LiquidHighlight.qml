import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property real diameter: 16
    property color fillColor: "#6478c8"

    property real fromCenterX: 0
    property real toCenterX: 0
    property real centerY: 0

    property real moveT: 1.0

    property real stretchFactor: 0.95
    property real squashFactor: 0.68

    property string pathData: ""

    readonly property real travelDistance: Math.abs(toCenterX - fromCenterX)
    readonly property real flowT: Math.sin(moveT * Math.PI)

    readonly property real visualWidth:
        Math.max(diameter, diameter + travelDistance * stretchFactor * flowT)

    readonly property real visualHeight:
        diameter * (1.0 - (1.0 - squashFactor) * flowT)

    readonly property real currentCenterX:
        fromCenterX + (toCenterX - fromCenterX) * moveT

    width: visualWidth
    height: visualHeight
    x: currentCenterX - width / 2
    y: centerY - height / 2

    function capsulePath(w, h) {
        var r = h / 2
        if (w < h)
            w = h

        return [
            "M ", r, " ", 0,
            "L ", w - r, " ", 0,
            "A ", r, " ", r, " 0 0 1 ", w - r, " ", h,
            "L ", r, " ", h,
            "A ", r, " ", r, " 0 0 1 ", r, " ", 0,
            "Z"
        ].join("")
    }

    function rebuild() {
        pathData = capsulePath(width, height)
    }

    function animateTo(targetCenterX, targetCenterY) {
        fromCenterX = currentCenterX
        toCenterX = targetCenterX
        centerY = targetCenterY
        moveT = 0.0
        moveAnim.restart()
    }

    function snapCircle(targetCenterX, targetCenterY) {
        fromCenterX = targetCenterX
        toCenterX = targetCenterX
        centerY = targetCenterY
        moveT = 1.0
        rebuild()
    }

    SequentialAnimation {
        id: moveAnim

        NumberAnimation {
            target: root
            property: "moveT"
            from: 0.0
            to: 1.0
            duration: 280
            easing.type: Easing.OutCubic
        }
    }

    onMoveTChanged: rebuild()
    onFromCenterXChanged: rebuild()
    onToCenterXChanged: rebuild()
    onCenterYChanged: rebuild()
    onWidthChanged: rebuild()
    onHeightChanged: rebuild()
    onDiameterChanged: rebuild()

    Component.onCompleted: rebuild()

    Shape {
        anchors.fill: parent
        antialiasing: true
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.fillColor
            strokeWidth: 0

            PathSvg {
                path: root.pathData
            }
        }
    }
}