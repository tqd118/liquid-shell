import QtQuick

import qs.theme
import qs.providers

Item {
    id: root

    property string query: ""
    property int currentIndex: 0

    readonly property var matches: AppsProvider.filter(query)
    readonly property bool hasResults: matches.length > 0

    property int rowHeight: 34
    property int rowRadius: 8
    property int rowItemSpacing: 2
    property int fontSize: 13
    property color colorText
    property color colorAccent
    property real selectedTintOpacity

    signal activated(var app)

    width: parent ? parent.width : 0
    height: hasResults ? Math.min(matches.length, 4) * rowHeight + Math.max(0, Math.min(matches.length, 4) - 1) * rowItemSpacing : 0
    visible: hasResults

    function moveUp() { currentIndex = Math.max(0, currentIndex - 1) }
    function moveDown() { currentIndex = Math.min(matches.length - 1, currentIndex + 1) }
    function activateCurrent() {
        const app = matches[currentIndex]
        if (app)
            root.activated(app)
    }

    ListView {
        id: appList
        anchors.fill: parent
        clip: true
        spacing: root.rowItemSpacing
        interactive: false
        currentIndex: root.currentIndex

        model: root.matches

        delegate: Item {
            id: entry
            required property var modelData
            required property int index
            width: appList.width
            height: root.rowHeight

            readonly property bool selected: index === root.currentIndex

            Rectangle {
                anchors.fill: parent
                radius: root.rowRadius
                color: entry.selected
                    ? Qt.rgba(root.colorAccent.r, root.colorAccent.g, root.colorAccent.b, root.selectedTintOpacity)
                    : "transparent"

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }

                Rectangle {
                    visible: entry.selected
                    width: 3
                    radius: 2
                    color: root.colorAccent
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 6
                }

                Text {
                    text: entry.modelData.name
                    color: entry.selected ? root.colorAccent : root.colorText
                    font.pixelSize: root.fontSize
                    font.weight: entry.selected ? Font.DemiBold : Font.Normal
                    elide: Text.ElideRight
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 14
                    anchors.rightMargin: 10

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.currentIndex = entry.index
                        root.activateCurrent()
                    }
                }
            }
        }
    }
}
