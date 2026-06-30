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

    signal activated(string query)

    width: parent ? parent.width : 0
    height: query.length > 0 ? rowHeight : 0
    visible: query.length > 0

    function execute() {
        root.activated(query)
    }

    Rectangle {
        anchors.fill: parent
        radius: root.rowRadius
        color: root.current
            ? Qt.rgba(root.colorAccent.r, root.colorAccent.g, root.colorAccent.b, root.selectedTintOpacity)
            : "transparent"

        Behavior on color {
            ColorAnimation { duration: 100 }
        }

        Rectangle {
            visible: root.current
            width: 3
            radius: 2
            color: root.colorAccent
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 6
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14
            anchors.rightMargin: 10
            spacing: 8

            Text {
                text: "\uf002" // nf-fa-search
                font.family: "Symbols Nerd Font"
                font.pixelSize: root.fontSize - 1
                color: root.current ? root.colorAccent : root.colorTextMuted
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "Search \u201c" + root.query + "\u201d"
                color: root.current ? root.colorAccent : root.colorTextMuted
                font.pixelSize: root.fontSize
                font.italic: true
                elide: Text.ElideRight
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 24
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.execute()
        }
    }
}
