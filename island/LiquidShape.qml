import QtQuick
import QtQuick.Shapes
import qs.theme

Item {
    id: root

    property real rectWidth: 280
    property real rectHeight: 40
    property real cornerRadius: 18

    property real deformT: 0
    property real maxPull: 16
    property real influenceRadius: 90
    property real cursorX: width / 2
    property real cursorY: height / 2

    property color fillColor: Theme.dark1

    readonly property alias shapeItem: mainShape

    property string _pathData: ""
    property bool _rebuildPending: false

    Behavior on deformT {
        NumberAnimation { duration: 360; easing.type: Easing.OutCubic }
    }

    Behavior on cursorX {
        SmoothedAnimation { velocity: 1200 }
    }

    Behavior on cursorY {
        SmoothedAnimation { velocity: 1200 }
    }

    function _clamp(v, lo, hi) {
        return Math.max(lo, Math.min(hi, v))
    }

    function _pt(x, y) {
        return { x: x, y: y }
    }

    function _warp(px, py, nx, ny, strength) {
        strength = (strength === undefined) ? 1.0 : strength
        if (deformT <= 0.001)
            return _pt(px, py)

        var dx = cursorX - px
        var dy = cursorY - py
        var dist = Math.sqrt(dx * dx + dy * dy)
        var t = _clamp(1.0 - dist / influenceRadius, 0.0, 1.0)
        t = t * t

        var pull = maxPull * t * deformT * strength
        return _pt(
            px + dx * t * 0.06 * deformT * strength + nx * pull,
            py + dy * t * 0.06 * deformT * strength + ny * pull
        )
    }

    function _catmullClosed(pts) {
        if (!pts || pts.length < 3)
            return ""

        var n = pts.length
        var d = "M " + pts[0].x + " " + pts[0].y
        for (var i = 0; i < n; ++i) {
            var p0 = pts[(i - 1 + n) % n]
            var p1 = pts[i]
            var p2 = pts[(i + 1) % n]
            var p3 = pts[(i + 2) % n]
            var c1x = p1.x + (p2.x - p0.x) / 6
            var c1y = p1.y + (p2.y - p0.y) / 6
            var c2x = p2.x - (p3.x - p1.x) / 6
            var c2y = p2.y - (p3.y - p1.y) / 6
            d += " C " + c1x + " " + c1y + " " + c2x + " " + c2y + " " + p2.x + " " + p2.y
        }
        return d + " Z"
    }

    function _sampleRect() {
        var cx = width / 2
        var cy = height / 2
        var w = rectWidth
        var h = rectHeight

        var x1 = cx - w * 0.5
        var y1 = cy - h * 0.5
        var x2 = cx + w * 0.5
        var y2 = cy + h * 0.5
        var r = _clamp(cornerRadius, 0, Math.min(w, h) / 2)
        var eS = 6
        var cS = 4
        var pts = []
        var i, t, a, x, y

        for (i = 0; i <= eS; ++i) {
            t = i / eS
            x = x1 + r + (x2 - x1 - 2 * r) * t
            pts.push(_warp(x, y1, 0, -1))
        }
        for (i = 1; i <= cS; ++i) {
            t = i / cS
            a = -Math.PI / 2 + t * (Math.PI / 2)
            x = (x2 - r) + Math.cos(a) * r
            y = (y1 + r) + Math.sin(a) * r
            pts.push(_warp(x, y, Math.cos(a), Math.sin(a)))
        }
        for (i = 1; i <= eS; ++i) {
            t = i / eS
            y = y1 + r + (y2 - y1 - 2 * r) * t
            pts.push(_warp(x2, y, 1, 0))
        }
        for (i = 1; i <= cS; ++i) {
            t = i / cS
            a = t * (Math.PI / 2)
            x = (x2 - r) + Math.cos(a) * r
            y = (y2 - r) + Math.sin(a) * r
            pts.push(_warp(x, y, Math.cos(a), Math.sin(a)))
        }
        for (i = 1; i <= eS; ++i) {
            t = i / eS
            x = x2 - r - (x2 - x1 - 2 * r) * t
            pts.push(_warp(x, y2, 0, 1))
        }
        for (i = 1; i <= cS; ++i) {
            t = i / cS
            a = Math.PI / 2 + t * (Math.PI / 2)
            x = (x1 + r) + Math.cos(a) * r
            y = (y2 - r) + Math.sin(a) * r
            pts.push(_warp(x, y, Math.cos(a), Math.sin(a)))
        }
        for (i = 1; i <= eS; ++i) {
            t = i / eS
            y = y2 - r - (y2 - y1 - 2 * r) * t
            pts.push(_warp(x1, y, -1, 0))
        }
        for (i = 1; i < cS; ++i) {
            t = i / cS
            a = Math.PI + t * (Math.PI / 2)
            x = (x1 + r) + Math.cos(a) * r
            y = (y1 + r) + Math.sin(a) * r
            pts.push(_warp(x, y, Math.cos(a), Math.sin(a)))
        }
        return pts
    }

    function _rebuild() {
        _pathData = _catmullClosed(_sampleRect())
    }

    function _scheduleRebuild() {
        if (_rebuildPending)
            return
        _rebuildPending = true
        Qt.callLater(function() {
            _rebuildPending = false
            _rebuild()
        })
    }

    Component.onCompleted: _rebuild()

    onWidthChanged: _scheduleRebuild()
    onHeightChanged: _scheduleRebuild()
    onDeformTChanged: _scheduleRebuild()
    onCursorXChanged: _scheduleRebuild()
    onCursorYChanged: _scheduleRebuild()
    onRectWidthChanged: _scheduleRebuild()
    onRectHeightChanged: _scheduleRebuild()
    onCornerRadiusChanged: _scheduleRebuild()

    Shape {
        id: mainShape
        anchors.fill: parent
        antialiasing: true
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.fillColor
            strokeWidth: 0
            fillRule: ShapePath.WindingFill
            PathSvg { path: root._pathData }
        }
    }
}
