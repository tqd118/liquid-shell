import QtQuick
import Quickshell.Io

import qs.theme
import qs.state

Item {
    id: root

    property string query: ""
    property bool current: false
    readonly property var result: evaluate(query)
    readonly property bool hasResult: result !== undefined && result !== null && !isNaN(result)

    property int rowHeight: 34
    property int rowRadius: 8
    property int fontSize: 13
    property color colorText
    property color colorTextMuted
    property color colorAccent
    property real tintOpacity
    property real selectedTintOpacity

    function evaluate(expr) {
        if (!expr)
            return undefined

        const trimmed = expr.trim()

        if (!/^[0-9+\-*/().\s]+$/.test(trimmed))
            return undefined

        if (!/[+\-*/]/.test(trimmed))
            return undefined

        try {
            const value = Function('"use strict"; return (' + trimmed + ')')()
            return typeof value === "number" && isFinite(value) ? value : undefined
        } catch (e) {
            return undefined
        }
    }

    function execute() {
        if (!hasResult)
            return

        copyProcess.command = ["wl-copy", String(result)]
        copyProcess.running = true
        copyPulse.start()
        IslandState.closeAll()
    }

    Process {
        id: copyProcess
    }

    width: parent ? parent.width : 0
    height: hasResult ? rowHeight : 0
    visible: height > 0
    clip: true

    Behavior on height {
        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
    }

    Rectangle {
        id: card
        width: parent.width
        height: root.rowHeight
        y: root.height - height
        radius: root.rowRadius
        opacity: root.hasResult ? 1 : 0
        scale: root.hasResult ? 1 : 0.9
        color: Qt.rgba(root.colorAccent.r, root.colorAccent.g, root.colorAccent.b,
                        root.current ? root.selectedTintOpacity : root.tintOpacity)

        Behavior on opacity {
            NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 1.4 }
        }
        Behavior on color {
            ColorAnimation { duration: 100 }
        }

        Rectangle {
            visible: root.current
            opacity: root.current ? 1 : 0
            width: 3
            radius: 2
            color: root.colorAccent
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 6

            Behavior on opacity {
                NumberAnimation { duration: 120 }
            }
        }

        Text {
            text: root.hasResult ? String(root.result) : ""
            color: root.current ? root.colorAccent : root.colorText
            font.pixelSize: root.fontSize + 1
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: clipboardIcon.left
            anchors.leftMargin: 14
            anchors.rightMargin: 8

            Behavior on color {
                ColorAnimation { duration: 100 }
            }
        }

        Text {
            id: clipboardIcon
            text: ""
            font.pixelSize: root.fontSize
            color: root.current ? root.colorAccent : root.colorTextMuted
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -1
            anchors.right: parent.right
            anchors.rightMargin: 12

            Behavior on color {
                ColorAnimation { duration: 100 }
            }

            SequentialAnimation {
                id: copyPulse
                NumberAnimation { target: clipboardIcon; property: "scale"; to: 0.97; duration: 90; easing.type: Easing.OutQuad }
                NumberAnimation { target: clipboardIcon; property: "scale"; to: 1.0; duration: 140; easing.type: Easing.OutBack }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.execute()
        }
    }
}
