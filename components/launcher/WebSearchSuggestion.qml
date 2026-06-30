import QtQuick

import qs.theme

Item {
    id: root

    property string query: ""
    property bool current: false

    property int rowHeight: 34
    property int rowRadius: 8
    property int fontSize: 13
    property color colorTextMuted
    property color colorAccent
    property real selectedTintOpacity

    readonly property bool hasQuery: query.length > 0

    signal activated(string query)

    width: parent ? parent.width : 0
    height: hasQuery ? rowHeight : 0
    visible: height > 0
    clip: true

    Behavior on height {
        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
    }

    function execute() {
        root.activated(query)
    }

    Rectangle {
        id: card
        width: parent.width
        height: root.rowHeight
        y: root.height - height
        radius: root.rowRadius
        opacity: root.hasQuery ? 1 : 0
        scale: root.hasQuery ? 1 : 0.9
        color: root.current
            ? Qt.rgba(root.colorAccent.r, root.colorAccent.g, root.colorAccent.b, root.selectedTintOpacity)
            : "transparent"

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

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14
            anchors.rightMargin: 10
            spacing: 8

            Text {
                text: ""
                font.pixelSize: root.fontSize - 1
                color: root.current ? root.colorAccent : root.colorTextMuted
                anchors.verticalCenter: parent.verticalCenter

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }
            }

            Text {
                text: "Search \u201c" + root.query + "\u201d"
                color: root.current ? root.colorAccent : root.colorTextMuted
                font.pixelSize: root.fontSize
                font.italic: true
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 24

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.execute()
        }
    }
}
